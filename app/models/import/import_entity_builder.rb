# frozen_string_literal: true

class ImportEntityBuilder
  def initialize(entity, factory)
    @factory = factory
    @entity = entity
  end

  def import(params)
    params = entity_params params
    import_entity_models params
    create_associations
    import_entity_one_relations params
    import_entity_many_relations params
  end

  def save
    node_model_builders.each { |builder| builder.save errors }
    relation_model_builders.each { |builder| builder.save errors }
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

  def create_associations
    node_model_builders.each do |builder|
      builder.create_associations @factory
    end
  end

  private

  def create_realtionship_associations
    realtion_model_builders.reject(&:relation_nodes_set?).each do |builder|
      builder.create_associations @factory
    end
  end

  def node_model_builders
    model_builders.select(&:model_node?)
  end

  def relation_model_builders
    model_builders.select(&:model_relation?)
  end

  def entity_params(params)
    return params until @entity.name?

    params[@entity.name]
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
      other_params = parameter_params params, param_name
      import_entity_relation other_entity, other_params
    end
  end

  def import_entity_many_relations(params)
    @entity.many_references.each do |param_name, other_entity|
      many_entity_params = parameter_params params, param_name
      many_entity_params.each do |entity_params|
        import_entity_relation other_entity, entity_params
      end
    end
  end

  def import_entity_relation(entity, entity_params)
    builder = ImportEntityBuilder.new entity, @factory
    builder.import entity_params
    create_associations
    builder.save
    errors.merge! builder.errors
    builder.clear
  end

  def parameter_params(params, param_name)
    params[param_name]
  end
end
