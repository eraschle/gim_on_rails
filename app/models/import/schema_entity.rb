# frozen_string_literal: true

require './app/models/import/import_config'

class SchemaEntity
  attr_reader :name, :parameters, :one_references, :many_references

  def initialize(name = :no_name)
    name = :no_name if name.blank?
    @name = name
    @model_configs = {}
    @one_references = {}
    @many_references = {}
  end

  def name?
    @name != :no_name
  end

  def add_parameter(import_param, definition)
    model_param = model_parameter_name definition
    config = model_config_by definition
    config.add_import_parameter import_param, model_param
  end

  def add_reference(import_param, one_reference, reference)
    if one_reference
      @one_references[import_param] = reference
    else
      @many_references[import_param] = reference
    end
  end

  def add_options(import_param, definition)
    options = model_parameter_options definition
    return unless options.keys.empty?

    add_search_parameter_options import_param, definition
  end

  def apply_model_configuration
    setup_model_configurations
    setup_one_relation_configurations
    setup_many_relation_configurations
  end

  private

  def setup_model_configurations
    models.each do |model_symbol|
      model_class = Object.const_get model_symbol
      model_class.setup config_of model_symbol
    end
  end

  def setup_one_relation_configuration
    @one_reference.each_value(&:apply_model_configuration)
  end

  def setup_many_relation_configuration
    @many_reference.each_value(&:apply_model_configuration)
  end

  def config?(model_symbol)
    symbol = to_symbol model_symbol
    @model_configs.key? symbol
  end

  def config_of(model_symbol)
    symbol = to_symbol model_symbol
    raise "No configuration for #{symbol}" unless config? symbol

    @model_configs[symbol]
  end

  def to_symbol(object)
    return object if object.is_a? Symbol

    name = object.is_a? Class ? object.name : object
    name.to_sym
  end

  ###
  # More or less are the following methods to read import schema
  ###

  def model_config_by(definition)
    symbol = to_symbol definition.first
    unless @model_configs.key? symbol
      config = ImportModelConfig.new
      @model_configs[symbol] = config
    end
    config_of symbol
  end

  def model_parameter_name(definition)
    return nil unless model_parameter_name? definition

    definition[1]
  end

  def model_parameter_name?(definition)
    definition.count > 1 &&
      definition[1].is_a?(Symbol)
  end

  def model_parameter_options?(definition)
    definition.last.is_a?(Hash)
  end

  def model_parameter_options(definition)
    return {} unless model_parameter_options? definition

    definition.last
  end

  def add_search_parameter_options(import_param, definition)
    options = model_parameter_options definition
    return unless options.key?(:search)

    config = model_config_by definition
    config.add_search_parameter import_param
  end
end
