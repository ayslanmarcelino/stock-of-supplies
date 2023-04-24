# == Schema Information
#
# Table name: people
#
#  id                               :bigint           not null, primary key
#  birth_date                       :date
#  cell_number                      :string
#  cns_number                       :string
#  document_number                  :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  marital_status_cd                :string
#  name                             :string
#  nickname                         :string
#  owner_type                       :string
#  telephone_number                 :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#  owner_id                         :bigint
#  unit_id                          :bigint
#
# Indexes
#
#  index_people_on_address_id  (address_id)
#  index_people_on_owner       (owner_type,owner_id)
#  index_people_on_unit_id     (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (unit_id => units.id)
#
class Person < ApplicationRecord
  IDENTITY_DOCUMENT_TYPES = [
    ['RG', :rg],
    ['RNE', :rne]
  ].freeze

  MARITAL_STATUSES = [
    [I18n.t('activerecord.attributes.person.marital_status_list.single'), :single],
    [I18n.t('activerecord.attributes.person.marital_status_list.married'), :married],
    [I18n.t('activerecord.attributes.person.marital_status_list.divorced'), :divorced],
    [I18n.t('activerecord.attributes.person.marital_status_list.widowed'), :widowed]
  ].freeze

  as_enum :marital_status, [:single, :married, :divorced, :widowed], prefix: true, map: :string

  belongs_to :unit
  belongs_to :address, optional: true, dependent: :destroy
  belongs_to :owner, polymorphic: true, optional: true

  has_one :user

  validates :document_number, uniqueness: { scope: [:owner_type, :unit_id] }, if: -> { document_number.present? }
  validates :document_number, :name, :cns_number, presence: true

  validates_length_of :cns_number, is: 15

  accepts_nested_attributes_for :address

  before_save :format_document_number

  def self.permitted_params
    [
      :id,
      :birth_date,
      :cell_number,
      :cns_number,
      :document_number,
      :identity_document_issuing_agency,
      :identity_document_number,
      :identity_document_type,
      :marital_status_cd,
      :name,
      :nickname,
      :telephone_number,
      :kind_cd,
      :unit_id,
      :owner_id,
      :owner_type
    ]
  end

  def format_document_number
    self.document_number = document_number.gsub!(/[^0-9a-zA-Z]/, '') unless document_number.match?(/\A\d+\z/)
  end
end
