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
    def model_config
      @model_config
    end

    def setup(config)
      @model_config = config
    end

    def find_import(params)
      return nil unless model_config.search_parameter?

      import_search = model_config.search_parameter
      search_value = params[import_search]

      model_param = model_config.to_model import_search

      found_models = where(model_param => search_value)
      found_models.count == 1 ? found_models.first : nil
    end

    def association_with_target?(model_symbol)
      return false unless associations?

      association_targets.include? model_symbol
    end

    # def relationship_target(relationship)
    #   relationship = relationship.name.to_sym if relationship.is_a? Class
    #   associations.each_value do |association|
    #     association_relation_symbol = association.relationship_class.name.to_sym
    #     next unless relationship == association_relation_symbol

    #     return target_symbol association
    #   end
    # end

    def association_targets
      return [] unless associations?

      associations.each_value.collect { |asso| target_symbol asso }
    end

    def association_with_target(model_symbol)
      return nil unless association_with_target? model_symbol

      associations.each_value do |association|
        next unless model_symbol == target_symbol(association)

        return association
      end
    end

    private

    def target_symbol(association)
      association.target_class.name.to_sym
    end

    def associations?
      respond_to? :associations
    end
  end
end
