class AddCurrentUnitToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :current_unit, foreign_key: { to_table: :units }
  end
end
