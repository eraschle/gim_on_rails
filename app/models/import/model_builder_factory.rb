# frozen_string_literal: true

require './app/models/import/import_model_builder'

class ModelBuilderFactory
  def initialize(main_model)
    @main_model = main_model
    @builders = {}
    create @main_model
  end

  def reset(model_symbol)
    model_symbol = to_symbol model_symbol
    @builders.delete model_symbol
  end

  def create(model_symbol)
    model_symbol = to_symbol model_symbol
    new_builder = ImportModelBuilder.new model_symbol
    @builders[model_symbol] = new_builder
    builder model_symbol
  end

  def builder(model_symbol)
    model_symbol = to_symbol model_symbol
    return nil unless created? model_symbol

    @builders[model_symbol]
  end

  def builders(model_symbols)
    model_builders = []
    model_symbols.each do |model_symbol|
      model_builders << builder(model_symbol) if created? model_symbol
    end
    model_builders
  end

  def main_builder
    @builders[@main_model]
  end

  def created?(model_symbol)
    return false if model_symbol.nil?

    model_symbol = to_symbol model_symbol
    @builders.key? model_symbol
  end

  private

  def to_symbol(object)
    return object if object.nil?
    return object if object.is_a? Symbol
    return object.name.to_sym if object.is_a? Class

    object.to_sym
  end
end
