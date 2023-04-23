class AddCurrentEnterpriseToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :current_enterprise, foreign_key: { to_table: :enterprises }
  end
end
