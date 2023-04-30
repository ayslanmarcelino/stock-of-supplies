# == Schema Information
#
# Table name: supplies
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
#
# Indexes
#
#  index_supplies_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
class Supply < ApplicationRecord
  belongs_to :created_by, class_name: 'User'

  validates :name, presence: true
  validates :name, uniqueness: true

  has_many :stocks

  def self.permitted_params
    [
      :id,
      :name,
      :created_by_id
    ]
  end
end
