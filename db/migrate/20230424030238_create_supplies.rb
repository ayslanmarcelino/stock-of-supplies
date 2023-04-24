class CreateSupplies < ActiveRecord::Migration[7.0]
  def change
    create_table :supplies do |t|
      t.string :name

      t.references :created_by, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
