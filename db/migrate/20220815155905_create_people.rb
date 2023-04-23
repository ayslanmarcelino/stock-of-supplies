class CreatePeople < ActiveRecord::Migration[7.0]
  def change
    create_table :people do |t|
      t.string :name
      t.string :trade_name
      t.string :nickname
      t.string :document_number
      t.string :cell_number
      t.string :telephone_number
      t.string :identity_document_type
      t.string :identity_document_number
      t.string :identity_document_issuing_agency
      t.string :marital_status_cd
      t.string :kind_cd
      t.date :birth_date

      t.references :owner, polymorphic: true
      t.references :address, foreign_key: true
      t.references :enterprise, foreign_key: true

      t.timestamps
    end
  end
end
