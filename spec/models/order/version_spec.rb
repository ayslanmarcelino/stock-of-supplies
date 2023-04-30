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
require 'rails_helper'

RSpec.describe Order::Version, type: :model do
  subject do
    described_class.new(
      aasm_state: aasm_state,
      order: order,
      responsible: responsible
    )
  end

  let!(:aasm_state) { Order::STATES.sample }
  let!(:order) { create(:order) }
  let!(:responsible) { create(:user) }

  context 'when sucessful' do
    it do
      expect(subject).to be_valid
    end
  end

  context 'when unsuccessful' do
    context 'when does not pass a required attribute' do
      [:aasm_state, :order, :responsible].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.order/version.#{attribute}")} não pode ficar em branco" }

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
