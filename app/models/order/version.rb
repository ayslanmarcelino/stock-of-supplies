# == Schema Information
#
# Table name: order_versions
#
#  id             :bigint           not null, primary key
#  aasm_state     :string
#  reason         :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  order_id       :bigint
#  responsible_id :bigint
#
# Indexes
#
#  index_order_versions_on_order_id        (order_id)
#  index_order_versions_on_responsible_id  (responsible_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (responsible_id => users.id)
#
class Order::Version < ApplicationRecord
  belongs_to :order
  belongs_to :responsible, class_name: 'User'

  validates :aasm_state, presence: true
end
