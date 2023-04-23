class AddReferenceAndColumnToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :active, :boolean, default: true

    add_reference :users, :person, foreign_key: true
  end
end
