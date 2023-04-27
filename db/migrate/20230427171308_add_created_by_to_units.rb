class AddCreatedByToUnits < ActiveRecord::Migration[7.0]
  def change
    add_reference :units, :created_by, foreign_key: { to_table: :users }
  end
end
