class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.integer :amount
      t.string :kind_cd
      t.string :reason
      t.date :expiration_date

      t.references :supply, foreign_key: true
      t.references :unit, foreign_key: true
      t.references :created_by, foreign_key: { to_table: :users }
      t.references :source, polymorphic: true

      t.timestamps
    end
  end
end
