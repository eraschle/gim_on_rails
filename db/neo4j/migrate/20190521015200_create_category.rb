# frozen_string_literal: true

class CreateCategory < Neo4j::Migrations::Base
  disable_transactions!
  def up
    add_constraint :Category, :uuid
    add_constraint :Category, :gim_id
  end

  def down
    drop_constraint :Category, :uuid
    drop_constraint :Category, :gim_id
  end
end
