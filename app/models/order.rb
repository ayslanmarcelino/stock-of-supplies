# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  amount          :string
#  approval_date   :date
#  delivery_date   :date
#  reason          :string
#  rejection_date  :date
#  status          :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved_by_id  :bigint
#  created_by_id   :bigint
#  delivered_by_id :bigint
#  rejected_by_id  :bigint
#  stock_id        :bigint
#
# Indexes
#
#  index_orders_on_approved_by_id   (approved_by_id)
#  index_orders_on_created_by_id    (created_by_id)
#  index_orders_on_delivered_by_id  (delivered_by_id)
#  index_orders_on_rejected_by_id   (rejected_by_id)
#  index_orders_on_stock_id         (stock_id)
#
# Foreign Keys
#
#  fk_rails_...  (approved_by_id => users.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (delivered_by_id => users.id)
#  fk_rails_...  (rejected_by_id => users.id)
#  fk_rails_...  (stock_id => stocks.id)
#
class Order < ApplicationRecord
  belongs_to :stock
  belongs_to :created_by, class_name: 'User'
  belongs_to :approved_by_id, class_name: 'User', optional: true
  belongs_to :delivered_by_id, class_name: 'User', optional: true
  belongs_to :rejected_by_id, class_name: 'User', optional: true
end
