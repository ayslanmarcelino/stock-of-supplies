class CreateUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :units do |t|
      t.string :email
      t.string :cnes_number
      t.string :kind_cd
      t.boolean :active, default: true

      t.string :name

      t.string :representative_name
      t.string :representative_document_number
      t.string :representative_cns_number
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
