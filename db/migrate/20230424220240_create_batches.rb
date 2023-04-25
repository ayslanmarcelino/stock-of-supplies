class CreateBatches < ActiveRecord::Migration[7.0]
  def change
    create_table :batches do |t|
      t.string :identifier
      t.date :arrived_date
      t.date :expiration_date
      t.integer :amount
      t.integer :remaining

      t.references :supply, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
