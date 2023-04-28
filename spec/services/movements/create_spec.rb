require 'rails_helper'

RSpec.describe Movements::Create, type: :service do
  subject { described_class.new(params: params, stock: stock, current_user: created_by, reason: reason, kind: kind) }

  let!(:params) do
    build(:stock, supply: supply, created_by: created_by, amount: amount, expiration_date: expiration_date, unit: unit,
                  arrived_date: occurrence_date, remaining: remaining)
  end
  let!(:supply) { create(:supply) }
  let!(:created_by) { create(:user) }
  let!(:amount) { 100 }
  let!(:unit) { create(:unit) }
  let!(:reason) { 'Recebido pelo Estado' }
  let!(:kind) { :input }
  let!(:expiration_date) { Date.current + 5.years }
  let!(:occurrence_date) { Date.current - 5.days }
  let!(:stock) { create(:stock) }
  let!(:remaining) { rand(1..100) }

  describe '#call' do
    context 'with valid params' do
      it 'creates a movement' do
        expect { subject.call }.to change { Movement.count }.by(1)
      end
    end

    context 'with invalid params' do
      [:kind, :reason, :created_by, :supply, :unit, :expiration_date, :occurrence_date, :stock].each do |attribute|
        context "when does not pass #{attribute}" do
          let!(attribute) {}
          let!(:message) { "#{I18n.t("activerecord.attributes.movement.#{attribute}")} não pode ficar em branco" }

          it do
            expect { subject.call }.to raise_error(ActiveRecord::RecordInvalid, message)
          end
        end
      end
    end
  end
end
