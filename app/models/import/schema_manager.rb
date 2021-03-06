# frozen_string_literal: true

require './app/models/import/schema_entity'
require './app/models/import/model_builder_factory'
require './app/models/import/import_entity_builder'

class SchemaManager
  def import(schema)
    @root = create_entity schema
  end

  def permit_parameters(params, rest_parameter)
    generator = PermitParamGenerator.new
    permit_parameters = generator.permit_params @root
    params.require(rest_parameter).permit(permit_parameters)
  end

  def create_builder(model_symbol)
    factory = ModelBuilderFactory.new model_symbol
    ImportEntityBuilder.new @root, factory
  end

  def apply_schema_configuration
    @root.apply_model_configuration
  end

  private

  def create_entity(schema, name = :no_name)
    entity = SchemaEntity.new name
    schema.each do |param, definition|
      if parameter? definition
        add_parameter entity, param, definition
      else if reference? definition
        add_reference entity, param, definition
      else
        raise "import parameter '#{param}' is neither a parameter or reference #{definition}"
      end
    end
    entity
  end

  def parameter?(definition)
    definition.is_a? Array
  end

  def add_parameter(entity, parameter, definition)
    entity.add_parameter parameter, definition
    entity.add_options parameter, definition
  end

  def add_reference(entity, parameter, definition)
    reference = create_reference definition
    is_one = one_reference? definition
    entity.add_reference parameter, is_one, reference
  end

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
end
