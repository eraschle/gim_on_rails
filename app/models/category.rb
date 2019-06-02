# frozen_string_literal: true

# Represents a category
class Category
  include Neo4j::ActiveNode
  include GimModelConcern
  include ImportModelConcern
  id_property :gim_id, type: String, on: :generate_gim_id
  property :name, type: String
  property :revit_id, type: Integer
end
