require 'rails_helper'

RSpec.describe Stocks::Create, type: :service do
  subject { described_class.new(params: params, unit: unit, reason: reason, kind: kind) }

  let!(:params) { build(:batch, supply: supply, created_by: created_by, amount: amount) }
  let!(:supply) { create(:supply) }
  let!(:created_by) { create(:user) }
  let!(:amount) { 100 }
  let!(:unit) { create(:unit) }
  let!(:reason) { 'Recebido pelo governo' }
  let!(:kind) { :input }

  describe '#call' do
    context 'with valid params' do
      it 'creates a stock' do
        expect { subject.call }.to change { Stock.count }.by(1)
      end
    end

    context 'with invalid params' do
      [:amount, :kind, :reason, :created_by, :supply, :unit].each do |attribute|
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
