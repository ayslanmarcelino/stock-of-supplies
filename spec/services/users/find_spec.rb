require 'rails_helper'

RSpec.describe Users::Find, type: :service do
  subject { described_class.new(email: email) }

  let!(:email) { FFaker::Internet.email }

  describe '#call' do
    context 'when the user exists' do
      let!(:user) { create(:user, email: email) }

      it 'returns the user' do
        result = subject.call
        expect(result).to eq(user)
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
