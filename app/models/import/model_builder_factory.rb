# frozen_string_literal: true

require './app/models/import/import_model_builder'

class ModelBuilderFactory
  def initialize(main_model)
    @main_model = main_model
    @builders = {}
  end

  def reset_all
    @builders.clear
  end

  def reset(model_symbol)
    @builders.delete model_symbol
  end

  def create(model_symbol)
    builder = ImportModelBuilder.new model_symbol
    @builders[model_symbol] = builder
  end

  def builder(model_symbol)
    return nil unless created? model_symbol

    @builders[model_symbol]
  end

  def builders(model_symbols)
    model_builders = []
    model_symbols.each do |model_symbol|
      model_builders << @builders[model_symbol]
    end
    model_builders
  end

  def all_created
    @builders.values.reject(&:model_node?)
  end

  def created?(model_symbol)
    @builders.key? model_symbol
  end
end
