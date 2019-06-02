# frozen_string_literal: true

# Represents a parameter name
class Parameter
  include Neo4j::ActiveNode
  include ImportModelConcern

  property :name, type: String

  has_one :in, :revit, rel_class: :HasRevitParameter,
                       model_class: :Family
  has_one :out, :unit, rel_class: :WithUnitOfQuantity,
                       model_class: :UnitOfMeasure
end
