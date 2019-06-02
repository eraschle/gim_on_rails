# frozen_string_literal: true

class Backup
  def import_relations(model, params, manager)
    configured_relations(manager).each do |relation|
      if relation.type == :has_one
        import_has_one(relation, model, params, manager)
      else
        import_has_many(relation, model, params, manager)
      end
    end
  end

  def model_params(config)
    attributes.collect { |att| att[0].to_sym }
              .reject { |att| config.excluded? att }
  end

  private

  def create_relation(association, model, target)
    relation_class = association.relationship_class
    relation_class.new model, target
  end

  def typed_relation_target?(association, manager)
    config = manager.config_by association.target_class
    config.type_name?
  end

  def import_has_one(association, model, params, manager)
    if association.relationship_class.present?
      import_typed_has_one association, model, params, manager
    else
      import_untyped_has_one association, model, params, manager
    end
  end

  def import_untyped_has_one(association, model, params, manager)
    config = manager.config_by association.target_class
    param_name = association.name
    param_name = config.translated param_name
    params = params[param_name]
    target = import_associated_model association, params, manager
    model.send "#{param_name}=", target
  end

  def import_typed_has_one(association, _model, params, manager)
    target = import_associated_model association, params, manager
    param_name = config.to_model param_name
    param_name = config.import_to_model param_name
    relation = merge_included_parameters relation, target, manager
    relation.save
  end

  def merge_included_parameters(relation, model, manager)
    model_config = manager.config_by model.class
    if model_config.included_model? relation.class
      params = model_config.filter_import_model_params params
    end
    return relation if params.nil?

    relation.from_import params, manager
  end

  def import_has_many(association, model, params, manager)
    list_key = association.name
    relations = params[list_key.to_sym]
    relations.each do |rel_params|
      import_typed_has_one association, model, rel_params, manager
    end
  end

  def mapped_permit_params(manager)
    config = manager.config_by self
    @included_params ||= []
    config.included_models.each do |model|
      included_model_params = included_model_parameter model, manager
      @included_params = @included_params.union(included_model_params)
    end
    @included_params
  end

  def included_model_parameter(model, manager)
    included_class = Object.const_get model
    included_config = manager.config_by included_class
    included_params = included_class.model_params(included_config)
    model_config = manager.config_by self
    included_params.select do |import_param|
      model_config.model_parameter_included? model, import_param
    end
    included_params.collect { |par| included_config.translated(par) }
  end

  def add_one_permit_params(params, manager, permited)
    attributes = configured_one_relations(manager)
    attributes.reject! { |att| @included_params.include? att.name }
    one_params = create_permit_params attributes, manager, permited
    params << one_params unless one_params.empty?
    included_params.collect { |par| included_config.to_model(par) }
    included_params.collect { |par| included_config.import_to_model(par) }
  end

  def add_many_permit_params(params, manager, permited)
    attributes = configured_many_relations(manager)
    many_params = create_permit_params attributes, manager, permited
    params << many_params unless many_params.empty?
    params
  end

  def create_permit_params(attributes, manager, permited)
    config = manager.config_by self
    permit_par = {}
    attributes.each do |att|
      param_name = config.translated att.name
      target_class = att.target_class
      unless permited.include? target_class.name.to_sym
        target_parmit_params = target_class.permit_params(manager, permited)
        permit_par[param_name] = target_parmit_params
      end
    end
    permit_par config.to_model att.name
  end

  def configured_many_relations(manager)
    configured_relations(manager).each.select do |ass|
      ass.type == :has_many
    end
  end

  def configured_one_relations(manager)
    configured_relations(manager).each.select do |ass|
      ass.type == :has_one
    end
  end

  def configured_relations(manager)
    config = manager.config_by self
    relation_associations = []
    associations.each do |key, value|
      relation_associations << value unless config.excluded? key
    end
    relation_associations.each.select do |ass|
      configured_association?(manager, ass)
    end
  end

  def configured_association?(manager, association)
    manager.config?(association.target_class)
    # || manager.config?(association.relationship_class)
  end
end
