# == Schema Information
#
# Table name: units
#
#  id                               :bigint           not null, primary key
#  active                           :boolean          default(TRUE)
#  birth_date                       :date
#  cell_number                      :string
#  cnes_number                      :string
#  email                            :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  kind_cd                          :string
#  name                             :string
#  representative_cns_number        :string
#  representative_document_number   :string
#  representative_name              :string
#  telephone_number                 :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#
# Indexes
#
#  index_units_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#
class Unit < ApplicationRecord
  KINDS = [
    [I18n.t('activerecord.attributes.unit.kind_list.unit'), :unit],
    [I18n.t('activerecord.attributes.unit.kind_list.pni'), :pni]
  ].freeze

  belongs_to :address, optional: true, dependent: :destroy

  validates :cnes_number, uniqueness: true, if: -> { cnes_number.present? }
  validates :email,
            :kind_cd,
            :cnes_number,
            :name,
            :representative_name,
            :representative_document_number,
            :representative_cns_number,
            presence: true

  accepts_nested_attributes_for :address

  as_enum :kind, [:unit, :pni], prefix: true, map: :string

  def self.permitted_params
    [
      :email,
      :cnes_number,
      :name,
      :kind_cd,
      :representative_name,
      :representative_document_number,
      :representative_cns_number,
      :cell_number,
      :telephone_number,
      :identity_document_type,
      :identity_document_number,
      :identity_document_issuing_agency,
      :birth_date,
      :address_id
    ]
  end
end
