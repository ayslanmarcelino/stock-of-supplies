require 'rails_helper'

RSpec.describe Users::Roles::Create, type: :service do
  subject { described_class.new(params: params, enterprise: enterprise) }

  let!(:params) do
    {
      representative_document_number: CPF.generate,
      representative_name: FFaker::Name.name,
      email: FFaker::Internet.email
    }
  end
  let!(:enterprise) { create(:enterprise) }

  describe '#call' do
    context 'when user does not exists' do
      it 'creates a person' do
        expect { subject.call }.to change { Person.count }.by(1)
      end

      it 'creates a user' do
        expect { subject.call }.to change { User.count }.by(1)
      end

      it 'creates a user role' do
        expect { subject.call }.to change { User::Role.count }.by(1)
      end

      it 'sets the user role kind to owner' do
        subject.call
        expect(User::Role.last.kind).to eq(:owner)
      end

      it 'sets the user role enterprise to the given enterprise' do
        subject.call
        expect(User::Role.last.enterprise).to eq(enterprise)
      end

      it 'sets the user role user to the created user' do
        subject.call
        expect(User::Role.last.user).to eq(User.last)
      end
    end

    context 'when user exists' do
      let!(:user) { create(:user) }
      let!(:params) do
        {
          representative_document_number: user.person&.document_number,
          representative_name: user.person&.name,
          email: user.email
        }
      end

      it 'does not create a person' do
        expect { subject.call }.not_to change { Person.count }
      end

      it 'does not create a user' do
        expect { subject.call }.not_to change { User.count }
      end

      it 'creates a user role' do
        expect { subject.call }.to change { User::Role.count }.by(1)
      end
    end
  end
end
