# == Schema Information
#
# Table name: stocks
#
#  id              :bigint           not null, primary key
#  amount          :integer
#  arrived_date    :date
#  expiration_date :date
#  identifier      :string
#  remaining       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  created_by_id   :bigint
#  supply_id       :bigint
#  unit_id         :bigint
#
# Indexes
#
#  index_stocks_on_created_by_id  (created_by_id)
#  index_stocks_on_supply_id      (supply_id)
#  index_stocks_on_unit_id        (unit_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#  fk_rails_...  (supply_id => supplies.id)
#  fk_rails_...  (unit_id => units.id)
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  subject do
    described_class.new(
      identifier: identifier,
      amount: amount,
      arrived_date: arrived_date,
      expiration_date: expiration_date,
      supply: supply,
      created_by: created_by,
      unit: unit,
      remaining: remaining
    )
  end

  let!(:identifier) { SecureRandom.base36 }
  let!(:amount) { rand(1..100) }
  let!(:arrived_date) { Date.current }
  let!(:expiration_date) { Date.current + 1.month }
  let!(:supply) { create(:supply) }
  let!(:created_by) { create(:user, :with_person) }
  let!(:unit) { create(:unit) }
  let!(:remaining) { rand(1..100) }

  context 'when successful' do
    it do
      expect(subject).to be_valid
    end

    context 'when has a stock with same identifier in other unit' do
      let!(:stock) { create(:stock, identifier: identifier) }

      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsuccessful' do
    context 'when does not pass a required attribute' do
      [:identifier, :arrived_date, :expiration_date, :supply, :created_by].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.stock.#{attribute}")} não pode ficar em branco" }

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

      context "when does not pass remaining" do
        let!(:remaining) {}
        let!(:message) { 'Restante não é um número válido' }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq(message)
        end
      end

      context "when does not pass unit" do
        let!(:unit) {}
        let!(:message) { 'Unidade não pode ficar em branco' }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq(message)
        end
      end
    end

    context 'when pass a existing attribute' do
      context 'when is same unit' do
        context 'when identifier' do
          let!(:stock) { create(:stock, identifier: identifier, unit: unit) }

          it do
            expect(subject).not_to be_valid
            expect(subject.errors.full_messages.to_sentence).to eq('Identificador já está em uso')
          end
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

      context 'when arrived_date' do
        let!(:arrived_date) { Date.current + 1.day }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('Chegada deve ser hoje ou antes')
        end
      end

      context 'when expiration_date' do
        let!(:expiration_date) { Date.current - 1.day }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('Validade deve ser hoje ou depois')
        end
      end
    end
  end
end
