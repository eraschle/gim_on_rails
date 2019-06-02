# frozen_string_literal: true

# Revit family model
class Family
  include Neo4j::ActiveNode
  include GimModelConcern
  include ImportModelConcern
  id_property :gim_id, type: String, on: :generate_gim_id
  property :name, type: String
  property :unique_id, type: String
  property :workplane_based, type: Boolean
  property :room_calculation_point, type: Boolean
  property :shared, type: Boolean
  property :always_vertical, type: Boolean
  property :round_dimension, type: String
  property :fitting_type, type: String
  property :library_path, type: String

  has_one :out, :category, type: 'HAS CATALOG', model_class: :Category,
                           unique: true

  has_many :out, :parameters, rel_class: :HasParameter, model_class: :Parameter

  alias id gim_id
end
