# == Schema Information
#
# Table name: orders
#
#  id                 :bigint           not null, primary key
#  amount             :integer
#  approval_date      :datetime
#  delivery_date      :datetime
#  reason             :string
#  rejection_date     :datetime
#  status_cd          :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  approved_by_id     :bigint
#  created_by_id      :bigint
#  delivered_by_id    :bigint
#  rejected_by_id     :bigint
#  requesting_unit_id :bigint
#  stock_id           :bigint
#
# Indexes
#
#  index_orders_on_approved_by_id      (approved_by_id)
#  index_orders_on_created_by_id       (created_by_id)
#  index_orders_on_delivered_by_id     (delivered_by_id)
#  index_orders_on_rejected_by_id      (rejected_by_id)
#  index_orders_on_requesting_unit_id  (requesting_unit_id)
#  index_orders_on_stock_id            (stock_id)
#
# Foreign Keys
#
#  fk_rails_...  (approved_by_id => users.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (delivered_by_id => users.id)
#  fk_rails_...  (rejected_by_id => users.id)
#  fk_rails_...  (requesting_unit_id => units.id)
#  fk_rails_...  (stock_id => stocks.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
