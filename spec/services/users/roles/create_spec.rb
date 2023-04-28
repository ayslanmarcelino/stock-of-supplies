require 'rails_helper'

RSpec.describe Users::Roles::Create, type: :service do
  subject { described_class.new(params: params, unit: unit) }

  let!(:params) do
    {
      representative_document_number: CPF.generate,
      representative_name: FFaker::Name.name,
      email: FFaker::Internet.email,
      representative_cns_number: FFaker.numerify('###############')
    }
  end
  let!(:unit) { create(:unit) }

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

      it 'sets the user role kind to coordinator' do
        subject.call
        expect(User::Role.last.kind).to eq(:coordinator)
      end

      it 'sets the user role unit to the given unit' do
        subject.call
        expect(User::Role.last.unit).to eq(unit)
      end

      it 'sets the user role user to the created user' do
        subject.call
        expect(User::Role.last.user).to eq(User.last)
      end
    end

    context 'when user exists' do
      let!(:user) { create(:user, :with_person) }
      let!(:params) do
        {
          representative_document_number: user.person.document_number,
          representative_name: user.person.name,
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
