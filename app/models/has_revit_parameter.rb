# frozen_string_literal: true

class HasRevitParameter
  include Neo4j::ActiveRel
  include ImportModelConcern
  from_class :any
  to_class :Parameter
  type 'HAS_REVIT_PARAMETER'
  property :family, type: Boolean
  property :revit, type: Boolean
  property :shared, type: Boolean
  property :built_in_parameter, type: String

  def family_parameter?
    @family
  end

  def revit_parameter?
    @revit
  end

  def shared_parameter?
    @shared
  end
end
