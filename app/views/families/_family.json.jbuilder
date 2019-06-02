# frozen_string_literal: true

json.extract! family, :id, :name, :unique_id, :workplane_based,
              :room_calculation_point, :shared, :always_vertical,
              :round_dimension, :fitting_type, :library_path,
              :created_at, :updated_at
json.parameters family.parameters do |parameter|
  json.name parameter.name
end

json.url family_url(family, format: :json)
