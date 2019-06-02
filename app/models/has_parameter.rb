# frozen_string_literal: true

class HasParameter
  include Neo4j::ActiveRel
  include ImportModelConcern
  from_class :any
  to_class :Parameter
  type 'HAS'
  creates_unique

  property :instance, type: Boolean
  property :formula, type: String
end
