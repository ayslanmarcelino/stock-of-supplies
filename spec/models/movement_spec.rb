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
#  stock_id        :bigint
#  created_by_id   :bigint
#  source_id       :bigint
#  supply_id       :bigint
#  unit_id         :bigint
#
# Indexes
#
#  index_movements_on_stock_id       (stock_id)
#  index_movements_on_created_by_id  (created_by_id)
#  index_movements_on_source         (source_type,source_id)
#  index_movements_on_supply_id      (supply_id)
#  index_movements_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (stock_id => stocks.id)
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
require 'rails_helper'

RSpec.describe Movement, type: :model do
  subject do
    described_class.new(
      amount: amount,
      kind: kind,
      reason: reason,
      created_by: created_by,
      supply: supply,
      unit: unit,
      expiration_date: expiration_date,
      source: source,
      occurrence_date: occurrence_date,
      stock: stock
    )
  end

  let!(:amount) { rand(1..100) }
  let!(:kind) { [:input, :output].sample }
  let!(:reason) { 'Recebido pelo Estado' }
  let!(:created_by) { create(:user) }
  let!(:supply) { create(:supply) }
  let!(:unit) { create(:unit) }
  let!(:expiration_date) { Date.current + 5.years }
  let!(:source) { create(:stock) }
  let!(:occurrence_date) { Date.current - 5.days }
  let!(:stock) { create(:stock) }

  context 'when successful' do
    it do
      expect(subject).to be_valid
    end
  end

  context 'when unsuccessful' do
    context 'when does not pass a required attribute' do
      [
        :amount,
        :kind,
        :reason,
        :created_by,
        :supply,
        :unit,
        :expiration_date,
        :source,
        :occurrence_date,
        :stock
      ].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.movement.#{attribute}")} não pode ficar em branco" }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end
    end
  end
end
