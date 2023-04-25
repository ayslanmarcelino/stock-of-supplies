# == Schema Information
#
# Table name: batches
#
#  id              :bigint           not null, primary key
#  amount          :string
#  arrived_date    :date
#  expiration_date :date
#  identifier      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_by_id   :bigint
#  supply_id       :bigint
#
# Indexes
#
#  index_batches_on_created_by_id  (created_by_id)
#  index_batches_on_supply_id      (supply_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#
class Batch < ApplicationRecord
  belongs_to :created_by, class_name: 'User'
  belongs_to :supply

  validates :amount,
            :arrived_date,
            :expiration_date,
            :identifier,
            presence: true

  validates :identifier, uniqueness: true
end