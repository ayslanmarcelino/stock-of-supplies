class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :status
      t.string :amount
      t.string :reason

      t.date :approval_date
      t.date :rejection_date
      t.date :delivery_date

      t.references :stock, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :approved_by, foreign_key: { to_table: :users }
      t.references :rejected_by, foreign_key: { to_table: :users }
      t.references :delivered_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
