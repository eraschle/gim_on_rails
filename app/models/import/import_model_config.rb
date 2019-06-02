# frozen_string_literal: true

class ImportModelConfig
  attr_reader :search_parameter

  def initialize
    @mapping = {}
    @search_parameter = :no_search_parameter
  end

  def add_import_parameter(import, model = nil)
    model = import if model.blank?
    @mapping[import] = model
  end

  def import_parameters
    @mapping.keys
  end

  def to_model(import)
    @mapping[import]
  end

  def search_parameter?
    @search_parameter != :no_search_parameter
  end

  private

  def add_search_parameter(parameter)
    return if parameter.nil?

    @search_parameter = parameter
  end
end
