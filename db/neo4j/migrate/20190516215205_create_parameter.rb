# frozen_string_literal: true

class CreateParameter < Neo4j::Migrations::Base
  disable_transactions!
  def up
    add_constraint :Parameter, :uuid
  end

  def down
    drop_constraint :Parameter, :uuid
  end
end
