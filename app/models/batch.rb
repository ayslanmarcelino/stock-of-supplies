# == Schema Information
#
# Table name: batches
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  arrived_date    :date
#  expiration_date :date
#  identifier      :string
#  remaining       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_by_id   :bigint
#  supply_id       :bigint
#  unit_id         :bigint
#
# Indexes
#
#  index_batches_on_created_by_id  (created_by_id)
#  index_batches_on_supply_id      (supply_id)
#  index_batches_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
class Batch < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  belongs_to :supply
  belongs_to :unit

  validates :amount,
            :identifier,
            presence: true
  validates :identifier, uniqueness: true
  validates :amount, numericality: { greater_than: 0 }
  validates :arrived_date, comparison: { less_than_or_equal_to: Date.current }
  validates :expiration_date, comparison: { greater_than_or_equal_to: Date.current }

  def self.permitted_params
    [
      :id,
      :amount,
      :arrived_date,
      :expiration_date,
      :identifier,
      :created_by_id,
      :supply_id,
      :unit_id
    ]
  end
end
