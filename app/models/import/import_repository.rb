# frozen_string_literal: true

require 'path_manager'

class ImportRepository
  def import_parameter_name(schema_entity)
    schema_entity[0]
  end

  def import_parameter_value(schema_entity)
    schema_entity[1]
  end

  def import_mapped_class(schema_entity)
    return unless parameter? schema_entity

    import_parameter_value(schema_entity).keys.first
  end

  def reference_type_name(schema_entity)
    return SchemaManager::SchemaEntity.default_typed unless reference? schema_entity

    reference_hash = import_reference_value schema_entity
    reference_key = reference_hash.keys.first
    reference_value = reference_hash[reference_key]
    return SchemaManager::SchemaEntity.default_typed if reference_value.is_a? Array

    type_name_key = reference_value.keys.first
    reference_value[type_name_key]
  end

  def switch_to_path(schema_entity, resource)
    return schema_entity if resource.parameter?

    p "SWITCH_TO: #{schema_entity}"
    reference_path = resource.reference_parameter
    p "PATH: #{reference_path}"
    schema_entity = schema_entity[reference_path]
    if resource.entity_name?
      resource_name_path = resource.typed
      schema_entity = schema_entity[resource_name_path]
    end
    schema_entity
  end

  def parameter?(schema_entity)
    schema_entity.is_a?(Array) &&
      reference?(schema_entity) == false
  end

  def reference?(schema_entity)
    one?(schema_entity) ||
      many?(schema_entity)
  end

  def one?(schema_entity)
    reference = import_reference_value schema_entity
    reference_key = reference.keys.first
    reference_key == :one
  end

  def many?(schema_entity)
    reference = import_reference_value schema_entity
    reference_key = reference.keys.first
    reference_key == :many
  end

  private

  def reference_type(sch); end
end
