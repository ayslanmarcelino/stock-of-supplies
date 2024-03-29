require 'rails_helper'

RSpec.describe Users::Create, type: :service do
  describe '#call' do
    subject { described_class.new(params: params, person: person, unit: unit) }

    let!(:params) { { email: FFaker::Internet.email } }
    let!(:person) { create(:person) }
    let!(:unit) { create(:unit) }

    context 'when user is found' do
      let!(:user_found) { create(:user, person: person) }

      before { allow(Users::Find).to receive(:call).with(email: params[:email]).and_return(user_found) }

      it 'returns the found user' do
        expect(subject.call).to eq(user_found)
      end

      it 'does not create a new user' do
        expect { subject.call }.not_to change { User.count }
      end

      it 'does not update the person' do
        expect { subject.call }.not_to change { person }
      end

      it 'does not send an email' do
        expect(UserMailer).not_to receive(:with)
        subject.call
      end
    end

    context 'when user is not found' do
      it 'creates a new user' do
        expect { subject.call }.to change { User.count }.by(1)
      end

      it 'sets the user attributes' do
        subject.call
        user = User.last
        expect(user.email).to eq(params[:email])
        expect(user.person).to eq(person)
        expect(user.current_unit).to eq(unit)
        expect(user.created_by).to eq(unit.created_by)
      end

      it 'updates the person' do
        expect { subject.call }.to change { person.reload.owner }.from(nil).to(an_instance_of(User))
      end

      it 'sends an e-mail' do
        expect(UserMailer).to receive(:with).and_call_original
        subject.call
      end
    end
  end
end
