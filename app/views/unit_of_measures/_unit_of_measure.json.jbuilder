# frozen_string_literal: true

json.extract! unit_of_measure, :id, :string, :created_at, :updated_at
json.url unit_of_measure_url(unit_of_measure, format: :json)
