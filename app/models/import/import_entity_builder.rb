# frozen_string_literal: true

class ImportEntityBuilder
  def initialize(entity, factory)
    @factory = factory
    @entity = entity
  end

  def import(params)
    entity_params = entity_import_params params
    import_entity_models entity_params
    create_associations
    import_entity_one_relations entity_params
    import_entity_many_relations entity_params
    save_entity_model_builders
    errors.empty?
  end

  def clear
    @entity.managed_models.each { |model| @factory.reset model }
  end

  def model_builders
    @factory.builders @entity.managed_models
  end

  def model
    @factory.main_builder.current
  end

  # return all import errors
  def errors
    @errors ||= {}
  end

  private

  def create_associations
    node_model_builders.each do |builder|
      builder.create_associations @factory
    end
  end

  def save_entity_model_builders
    node_model_builders.each { |model_builder| model_builder.save errors }
    relation_model_builders.each { |model_builder| model_builder.save errors }
  end

  def node_model_builders
    model_builders.select(&:model_node?)
  end

  def relation_model_builders
    model_builders.select(&:model_relation?)
  end

  def entity_import_params(params)
    return params until @entity.name?

    params[@entity.name]
  end

  def parameter_import_params(params, param_name)
    params[param_name]
  end

  def import_entity_models(params)
    @entity.managed_models.each do |model|
      unless @factory.created? model
        builder = @factory.create model
        builder.new_instance params
      end
      builder = @factory.builder model
      builder.import params
    end
  end

  def import_entity_one_relations(params)
    @entity.one_references.each do |param_name, other_entity|
      other_params = parameter_import_params params, param_name
      import_entity_relation other_entity, other_params
    end
  end

  def import_entity_many_relations(params)
    @entity.many_references.each do |param_name, other_entity|
      many_entity_params = parameter_import_params params, param_name
      many_entity_params.each do |entity_params|
        import_entity_relation other_entity, entity_params
      end
    end
  end

  def import_entity_relation(entity, entity_params)
    builder = ImportEntityBuilder.new entity, @factory
    builder.import entity_params
    errors.merge! builder.errors
    builder.clear
    # create_associations
  end
end
