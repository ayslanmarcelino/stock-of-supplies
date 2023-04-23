# == Schema Information
#
# Table name: enterprises
#
#  id                               :bigint           not null, primary key
#  active                           :boolean          default(TRUE)
#  birth_date                       :date
#  cell_number                      :string
#  document_number                  :string
#  email                            :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  name                             :string
#  opening_date                     :date
#  representative_document_number   :string
#  representative_name              :string
#  telephone_number                 :string
#  trade_name                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#
# Indexes
#
#  index_enterprises_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#
class Enterprise < ApplicationRecord
  IDENTITY_DOCUMENT_TYPES = [
    ['RG', :rg],
    ['RNE', :rne]
  ].freeze

  belongs_to :address, optional: true, dependent: :destroy

  validates :document_number, uniqueness: true, if: -> { document_number.present? }
  validates :email,
            :document_number,
            :name,
            :representative_name,
            :representative_document_number,
            presence: true

  accepts_nested_attributes_for :address

  before_save :format_document_number

  def self.permitted_params
    [
      :email,
      :document_number,
      :name,
      :trade_name,
      :opening_date,
      :representative_name,
      :representative_document_number,
      :cell_number,
      :telephone_number,
      :identity_document_type,
      :identity_document_number,
      :identity_document_issuing_agency,
      :birth_date,
      :address_id
    ]
  end

  def formatted_name
    "#{name} | #{CNPJ.new(document_number).formatted}"
  end

  def format_document_number
    self.document_number = document_number.gsub!(/[^0-9a-zA-Z]/, '') unless document_number.match?(/\A\d+\z/)
  end
end
