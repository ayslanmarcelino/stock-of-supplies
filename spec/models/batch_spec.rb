# == Schema Information
#
# Table name: batches
#
#  id              :bigint           not null, primary key
#  amount          :integer
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
require 'rails_helper'

RSpec.describe Batch, type: :model do
  subject do
    described_class.new(
      identifier: identifier,
      amount: amount,
      arrived_date: arrived_date,
      expiration_date: expiration_date,
      supply: supply,
      created_by: created_by
    )
  end

  let!(:identifier) { SecureRandom.base36 }
  let!(:amount) { rand(1..100) }
  let!(:arrived_date) { Date.current }
  let!(:expiration_date) { Date.current + 1.month }
  let!(:supply) { create(:supply) }
  let!(:created_by) { create(:user, :with_person) }

  context 'when successful' do
    it do
      expect(subject).to be_valid
    end
  end

  context 'when unsuccessful' do
    context 'when does not pass a required attribute' do
      [:identifier, :arrived_date, :expiration_date, :supply, :created_by].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.batch.#{attribute}")} não pode ficar em branco" }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq(message)
          end
        end
      end

      context "when does not pass amount" do
        let!(:amount) {}
        let!(:message) { 'Quantidade não pode ficar em branco and Quantidade não é um número válido' }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq(message)
        end
      end
    end

    context 'when pass a existing attribute' do
      context 'when identifier' do
        let!(:batch) { create(:batch, identifier: identifier) }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('Nome já está em uso')
        end
      end
    end

    context 'when pass a incorrect attribute' do
      context 'when amount' do
        let!(:amount) { -1 }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('Quantidade deve ser maior que 0')
        end
      end

      context 'when expiration_date' do
        let!(:expiration_date) { Date.current - 1.day }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('Data de validade deve ser hoje ou depois')
        end
      end
    end
  end
end
