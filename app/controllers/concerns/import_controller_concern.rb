# frozen_string_literal: true

require './app/models/import/schema_manager'

module ImportControllerConcern
  extend ActiveSupport::Concern

  def permit_import_parameters(params, rest_parameter)
    manager.apply_schema_configuration
    permit_params = manager.permit_parameters params, rest_parameter
    permit_params
  end

  protected

  def manager
    self.class.manager
  end

  module ClassMethods
    def import_schema(schema)
      manager.import schema
    end

    def manager
      @manager ||= SchemaManager.new
      @manager
    end
  end
end
