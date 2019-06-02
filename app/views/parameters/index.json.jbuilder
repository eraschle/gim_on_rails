# frozen_string_literal: true

json.array! @parameters, partial: 'parameters/parameter', as: :parameter
