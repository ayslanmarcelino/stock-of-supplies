# == Schema Information
#
# Table name: stocks
#
#  id            :bigint           not null, primary key
#  amount        :integer
#  kind_cd       :string
#  reason        :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
#  supply_id     :bigint
#  unit_id       :bigint
#
# Indexes
#
#  index_stocks_on_created_by_id  (created_by_id)
#  index_stocks_on_supply_id      (supply_id)
#  index_stocks_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
class Stock < ApplicationRecord
  KINDS = [
    [I18n.t('activerecord.attributes.stock.kind_list.input'), :input],
    [I18n.t('activerecord.attributes.stock.kind_list.output'), :output]
  ].freeze

  belongs_to :created_by, class_name: 'User'
  belongs_to :supply
  belongs_to :unit

  validates :amount,
            :kind_cd,
            :reason,
            presence: true

  as_enum :kind, [:input, :output], prefix: true, map: :string

  ransacker :created_at, type: :date do
    Arel.sql('date(created_at)')
  end

  def translated_kind
    I18n.t("activerecord.attributes.stock.kind_list.#{kind}")
  end
end
