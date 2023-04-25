# == Schema Information
#
# Table name: stocks
#
#  id         :bigint           not null, primary key
#  amount     :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  supply_id  :bigint
#  unit_id    :bigint
#
# Indexes
#
#  index_stocks_on_supply_id  (supply_id)
#  index_stocks_on_unit_id    (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
class Stock < ApplicationRecord
end
