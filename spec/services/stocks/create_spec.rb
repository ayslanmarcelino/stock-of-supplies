require 'rails_helper'

RSpec.describe Stocks::Create, type: :service do
  subject { described_class.new(params: params, batch: batch, reason: reason, kind: kind) }

  let!(:params) do
    build(:batch, supply: supply, created_by: created_by, amount: amount, expiration_date: expiration_date, unit: unit,
                  arrived_date: occurrence_date)
  end
  let!(:supply) { create(:supply) }
  let!(:created_by) { create(:user) }
  let!(:amount) { 100 }
  let!(:unit) { create(:unit) }
  let!(:reason) { 'Recebido pelo Estado' }
  let!(:kind) { :input }
  let!(:expiration_date) { Date.current + 5.years }
  let!(:occurrence_date) { Date.current - 5.days }
  let!(:batch) { create(:batch) }

  describe '#call' do
    context 'with valid params' do
      it 'creates a stock' do
        expect { subject.call }.to change { Stock.count }.by(1)
      end
    end

    context 'with invalid params' do
      [:amount, :kind, :reason, :created_by, :supply, :unit, :expiration_date, :occurrence_date, :batch].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.stock.#{attribute}")} não pode ficar em branco" }

          it do
            expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid, message)
          end
        end
      end
    end
  end
end
