# frozen_string_literal: true

class PermitParamGenerator
  def permit_params(entity)
    parameters = entity_parameters entity
    parameters = add_one_references entity, parameters
    parameters = add_many_references entity, parameters
    parameters = { entity.name => parameters } if entity.name?
    parameters
  end

  private

  def entity_parameters(entity)
    entity.parameters
  end

  def add_one_references(entity, permit_params)
    parameters = permit_one_reference entity
    permit_params << parameters unless parameters.empty?
    permit_params
  end

  def permit_one_reference(entity)
    entity.one_references.collect do |param, one_entity|
      create_reference_permit_params param, one_entity
    end
  end

  def add_many_references(entity, permit_params)
    parameters = permit_many_reference entity
    permit_params << parameters unless parameters.empty?
    permit_params
  end

  def permit_many_reference(entity)
    entity.many_references.collect do |param, many_entity|
      create_reference_permit_params param, many_entity
    end
  end

  def create_reference_permit_params(param_name, reference_entity)
    reference_params = permit_params reference_entity
    { param_name => reference_params }
  end
end
