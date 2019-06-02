# frozen_string_literal: true

module Api
  module V1
    module Revit
      class RevitController < ActionController::Base
        include ImportControllerConcern
        protect_from_forgery unless: -> { request.format.json? }
      end
    end
  end
end
