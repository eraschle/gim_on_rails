# frozen_string_literal: true

class UnitOfMeasure
  include Neo4j::ActiveNode
  include ImportModelConcern
  property :name, type: String
  property :storage_type, type: String
end
