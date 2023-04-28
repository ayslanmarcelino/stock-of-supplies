# == Schema Information
#
# Table name: movements
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  expiration_date :date
#  kind_cd         :string
#  occurrence_date :date
#  reason          :string
#  source_type     :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  batch_id        :bigint
#  created_by_id   :bigint
#  source_id       :bigint
#  supply_id       :bigint
#  unit_id         :bigint
#
# Indexes
#
#  index_movements_on_batch_id       (batch_id)
#  index_movements_on_created_by_id  (created_by_id)
#  index_movements_on_source         (source_type,source_id)
#  index_movements_on_supply_id      (supply_id)
#  index_movements_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (batch_id => batches.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
class Movement < ApplicationRecord
  KINDS = [
    [I18n.t('activerecord.attributes.movement.kind_list.input'), :input],
    [I18n.t('activerecord.attributes.movement.kind_list.output'), :output]
  ].freeze

  belongs_to :batch
  belongs_to :supply
  belongs_to :unit
  belongs_to :created_by, class_name: 'User'
  belongs_to :source, polymorphic: true

  validates :amount,
            :kind_cd,
            :reason,
            :expiration_date,
            :occurrence_date,
            presence: true

  as_enum :kind, [:input, :output], prefix: true, map: :string

  def translated_kind
    I18n.t("activerecord.attributes.movement.kind_list.#{kind}")
  end
end
