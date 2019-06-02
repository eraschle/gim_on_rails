# frozen_string_literal: true
# require './app/models/import/schema_manager'

module Api
  module V1
    module Revit
      class FamiliesController < RevitController
        import_schema name: %i[Family],
                      # id_unique: { UniqueId: :id },
                      category: {
                        one: :no_name,
                        model: {
                          name: [:Category, { search: true }],
                          revit_id: %i[Category]
                        }
                      },
                      is_work_plane_based: %i[Family workplane_based],
                      room_calculation_point: %i[Family],
                      shared_family: %i[Family shared],
                      always_vertical: %i[Family],
                      dimension_round: %i[Family round_dimension],
                      fitting_type: %i[Family],
                      library_path: [:Family, { search: true }],
                      parameters: {
                        many: :parameter,
                        model: {
                          name: [:Parameter, { search: true }],
                          parameter_kind: [
                            :UnitOfMeasure, :name, { search: true }
                          ],
                          is_instance_parameter: %i[HasParameter instance],
                          unit: %i[
                            WithUnitOfQuantity unit_of_quantity
                          ],
                          revit_parameter: %i[
                            HasRevitParameter built_in_parameter
                          ],
                          formula: %i[HasParameter],
                          is_revit_parameter: [
                            :HasRevitParameter, :revit, { search: true }
                          ],
                          is_family: %i[HasRevitParameter family],
                          is_shared_guid: %i[HasRevitParameter shared]
                        }
                      }

        # GET /families/1
        # GET /families/1.json
        def show; end

        def create
          builder = manager.create_builder :Family
          if builder.import family_params
            model = builder.model
            render json: model, status: :created
          else
            errors = builder.errors
            render json: errors, status: :unprocessable_entity
          end
        end

        private

        def family_params
          permit_import_parameters params, :family
        end
      end
    end
  end
end
