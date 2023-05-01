# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  aasm_state         :string
#  amount             :integer
#  reason             :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  created_by_id      :bigint
#  requesting_unit_id :bigint
#  stock_id           :bigint
#
# Indexes
#
#  index_orders_on_created_by_id       (created_by_id)
#  index_orders_on_requesting_unit_id  (requesting_unit_id)
#  index_orders_on_stock_id            (stock_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (requesting_unit_id => units.id)
#  fk_rails_...  (stock_id => stocks.id)
#
class Order < ApplicationRecord
  include Orders

  STATES = [
    :pending,
    :approved,
    :rejected,
    :delivered,
    :finished
  ].freeze

  REASONS = [
    'Estoque comprometido',
    'Outros'
  ].freeze

  belongs_to :stock
  belongs_to :requesting_unit, class_name: 'Unit'
  belongs_to :created_by, class_name: 'User'

  has_many :versions

  as_enum :state, STATES, map: :string, source: :aasm_state

  validates :amount, :aasm_state, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def self.permitted_params
    [
      :id,
      :amount,
      :stock_id
    ]
  end
end
