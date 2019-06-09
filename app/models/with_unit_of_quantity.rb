# frozen_string_literal: true

class WithUnitOfQuantity
  include Neo4j::ActiveRel
  include ImportModelConcern
  from_class :Parameter
  to_class :UnitOfMeasure
  type 'WITH_UNIT_OF_QUANTITY'
  property :unit_of_quantity, type: String
  creates_unique on: [:unit_of_quantity]
end
