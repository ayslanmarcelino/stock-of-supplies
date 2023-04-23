require 'rails_helper'

RSpec.describe People::Find, type: :service do
  subject { described_class.new(document_number: document_number) }

  let!(:document_number) { CPF.generate }
  let!(:enterprise) { create(:enterprise) }

  describe '#call' do
    context 'when the user exists' do
      let!(:person) { create(:person, :person, document_number: document_number) }

      it 'returns the user' do
        result = subject.call
        expect(result).to eq(person)
      end
    end

    context 'when the user does not exist' do
      it 'returns nil' do
        result = subject.call
        expect(result).to be_nil
      end
    end
  end
end
