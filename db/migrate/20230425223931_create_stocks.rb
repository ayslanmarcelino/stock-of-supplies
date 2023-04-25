class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.integer :amount

      t.references :supply, foreign_key: true
      t.references :unit, foreign_key: true

      t.timestamps
    end
  end
end
