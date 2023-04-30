class CreateOrderVersions < ActiveRecord::Migration[7.0]
  def change
    create_table :order_versions do |t|
      t.string :aasm_state
      t.string :reason

      t.references :order, foreign_key: true
      t.references :responsible, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
