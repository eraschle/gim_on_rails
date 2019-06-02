# frozen_string_literal: true

json.extract! parameter, :name, :created_at, :updated_at
json.url parameter_url(parameter, format: :json)
