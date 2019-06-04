# frozen_string_literal: true

class ImportEntityBuilder
  def initialize(model_symbol, entity)
    @model_symbol = model_symbol
    @entity = entity
    raise "'#{@model_symbol}' is not managed by '#{@entity.class.name}'"
  end

  def instance
    @instance ||= model_class.new
  end

  # import params values and returns true if all goof.
  # return false if some errors occurs during import.
  def import(params)
    # model parameter of model is mapped
    instance = import_model params
    others = import_other_models params

    # import schema entity references
    one_references = import_one_references params
    many_references = import_many_references params
  end

  # return all import errors
  def errors
    @errors ||= []
  end

  # returns imported and merged model
  def model
    instance
  end

  private

  def other_models(source)
    @entity.models.reject { |model| model == source }
  end

  def import_model(params)
    import_model_data params, @model_symbol
  end

  def import_other_models(params)
    other_models = other_models @model_symbol
    other_models.each do |model|
      other_instance = import_model_data params, model
    end
  end

  def import_model_data(params, model_symbol)
    config = @entity.config_of model_symbol

    model_class = Object.const_get model_symbol
    instance = model_class.find_or_create params, config
    instance.import params
  end
end
