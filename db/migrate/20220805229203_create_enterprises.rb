class CreateEnterprises < ActiveRecord::Migration[7.0]
  def change
    create_table :enterprises do |t|
      t.string :email
      t.string :document_number
      t.boolean :active, default: true

      t.string :name
      t.string :trade_name
      t.date :opening_date

      t.string :representative_name
      t.string :representative_document_number
      t.string :cell_number
      t.string :telephone_number
      t.string :identity_document_type
      t.string :identity_document_number
      t.string :identity_document_issuing_agency
      t.date :birth_date

      t.references :address, foreign_key: true

      t.timestamps
    end
  end
end
