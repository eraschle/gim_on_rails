# frozen_string_literal: true

class CreateUnitOfMeasure < Neo4j::Migrations::Base
  def up
    add_constraint :UnitOfMeasure, :uuid
  end

  def down
    drop_constraint :UnitOfMeasure, :uuid
  end
end
