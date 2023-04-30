class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :amount

      t.string :aasm_state
      t.string :reason

      t.datetime :approval_date
      t.datetime :rejection_date
      t.datetime :delivery_date

      t.references :stock, foreign_key: true
      t.references :requesting_unit, foreign_key: { to_table: :units }
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.references :rejected_by, foreign_key: { to_table: :users }
      t.references :delivered_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
