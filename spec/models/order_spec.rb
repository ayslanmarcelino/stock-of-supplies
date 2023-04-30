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
require 'rails_helper'

RSpec.describe Order, type: :model do
  subject do
    described_class.new(
      aasm_state: aasm_state,
      amount: amount,
      reason: reason,
      created_by: created_by,
      requesting_unit: requesting_unit,
      stock: stock
    )
  end

  let!(:aasm_state) { Order::STATES.sample }
  let!(:amount) { rand(1..100) }
  let!(:reason) { 'Motivo aleatório' }
  let!(:created_by) { create(:user, :with_person) }
  let!(:requesting_unit) { create(:unit) }
  let!(:stock) { create(:stock) }

  context 'when sucessful' do
    it do
      expect(subject).to be_valid
    end
  end

  context 'when unsuccessful' do
    context 'when does not pass a required attribute' do
      [:aasm_state, :amount, :created_by, :requesting_unit, :stock].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.order.#{attribute}")} não pode ficar em branco" }

          before { subject.aasm_state = nil if attribute == :aasm_state }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end
    end
  end
end
