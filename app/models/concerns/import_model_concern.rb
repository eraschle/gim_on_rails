# frozen_string_literal: true

module ImportModelConcern
  extend ActiveSupport::Concern

  def import(params)
    config.import_parameters.each do |import_param|
      model_param = config.to_model import_param
      import_value = params[import_param]
      send("#{model_param}=", import_value)
    end
  end

  def export(instance); end

  private

  def config
    self.class.model_config
  end

  module ClassMethods
    def setup(config)
      @model_config = config
    end

    def find_or_create(params)
      found_model = find_by params
      found_model.nil? ? new : found_model
    end

    private

    def model_config
      @model_config
    end

    def find_by(params)
      return nil unless @model_config.search_parameter?

      import_search = @model_config.search_parameter
      search_value = params[import_search]
      model_param = @model_config.to_model import_search

      found_models = where(model_param == search_value)
      found_models.count == 1 ? found_models.first : nil
    end
  end
end
