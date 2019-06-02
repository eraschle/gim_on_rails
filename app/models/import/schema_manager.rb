# frozen_string_literal: true

require './app/models/import/schema_entity'

class SchemaManager
  def import(schema)
    @root = create_entity schema
  end

  def create_entity(schema, name = nil)
    entity = SchemaEntity.new name
    schema.each do |param, definition|
      if parameter? definition
        setup_parameter entity, param, definition
      elsif reference? definition
        setup_references entity, param, definition
      end
    end
    entity
  end

  def permit_parameters(params, rest_parameter)
    generator = PermitParamGenerator.new
    permit_parameters = generator.permit_params @root
    params.require(rest_parameter).permit(permit_parameters)
  end

  def create_builder(model_symbol)
    ImportEntityBuilder.new model_symbol, @root
  end

  def apply_schema_configuration
    @root.apply_model_configuration
  end

  private

  # add the mapping of import parameter
  # to a model and one of its parameter
  def setup_parameter(entity, parameter, definition)
    entity.add_parameter parameter, definition
    entity.add_options parameter, definition
  end

  def setup_references(entity, parameter, definition)
    reference = create_reference definition
    is_one = one_reference? definition
    entity.add_schema_reference parameter, is_one, reference
    entity.add_reference parameter, is_one, reference

  def create_reference(definition)
    ref_name = reference_type_name definition
    ref_schema = definition[:model]
    create_entity ref_schema, ref_name
  end

  def reference?(definition)
    definition.is_a?(Hash) &&
      (one_reference?(definition) ||
        many_reference?(definition))
  end

  def one_reference?(definition)
    definition.key? :one
  end

  def many_reference?(definition)
    definition.key? :many
  end

  def reference_type_name(definition)
    reference_type = one_reference?(definition) ? :one : :many
    definition[reference_type]
  end

  def parameter?(definition)
    definition.is_a? Array
  end
end
