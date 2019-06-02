# frozen_string_literal: true

module ImportControllerConcern
  extend ActiveSupport::Concern

  def permit_import_parameters(params, rest_parameter)
    manager.permit_parameters params, rest_parameter
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
