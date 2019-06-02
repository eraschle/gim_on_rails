# frozen_string_literal: true

class CreateFamily < Neo4j::Migrations::Base
  disable_transactions!
  def up
    add_constraint :Family, :uuid
    add_constraint :Family, :gim_id
    add_index :Family, :name
  end

  def down
    drop_constraint :Family, :uuid
    drop_constraint :Family, :gim_id
    drop_index :Family, :name
  end
end
