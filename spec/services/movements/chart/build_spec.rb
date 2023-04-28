require 'rails_helper'

RSpec.describe Movements::Chart::Build, type: :service do
  subject { described_class.new(user: user) }

  let!(:user) { create(:user) }
  let!(:unit) { create(:unit) }
  let!(:supply) { create(:supply, name: 'Vacina influenza') }
  let!(:other_supply) { create(:supply, name: 'Vacina febre amarela') }
  let!(:another_supply) { create(:supply, name: 'Vacina COVID-19') }
  let!(:input_kind) { :input }
  let!(:output_kind) { :output }
  let!(:result) do
    {
      labels: [
        'Vacina COVID-19',
        'Vacina febre amarela',
        'Vacina influenza'
      ],
      values: [
        -10, 10, 10
      ]
    }
  end

  before do
    user.update(current_unit: unit)

    create(:movement, unit: unit, amount: 10, supply: supply, kind: :input)
    create(:movement, unit: unit, amount: 10, supply: other_supply, kind: :input)
    create(:movement, unit: unit, amount: 20, supply: another_supply, kind: :output)
    create(:movement, unit: unit, amount: 10, supply: another_supply, kind: :input)

    create_list(:movement, 2, supply: supply, kind: input_kind)
    create_list(:movement, 3, supply: other_supply, kind: input_kind)
    create_list(:movement, 1, supply: other_supply, kind: output_kind)
    create_list(:movement, 4, supply: another_supply, kind: output_kind)
  end

  describe '#call' do
    it 'returns chart data' do
      response = subject.call

      expect(response).to eq(result)
    end
  end
end
