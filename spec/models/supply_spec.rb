# == Schema Information
#
# Table name: supplies
#
#  id            :bigint           not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  created_by_id :bigint
#
# Indexes
#
#  index_supplies_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (created_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Supply, type: :model do
  subject { described_class.new(name: name, created_by: user) }

  let!(:name) { 'Omalizumabe' }
  let!(:user) { create(:user) }

  context 'when sucessful' do
    context 'when first supply created by user' do
      context 'when first name created' do
        it do
          expect(subject).to be_valid
        end
      end
    end

    context 'when has same user in created_by' do
      let!(:supply) { create(:supply, name: 'Infliximabe', created_by: user) }

      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsuccessful' do
    context 'when has a supply with same name' do
      let!(:supply) { create(:supply, name: name) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Nome imunobiológico já está em uso')
      end
    end

    context 'when does not pass a name' do
      let!(:name) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Nome imunobiológico não pode ficar em branco')
      end
    end

    context 'when does not pass a created_by' do
      let!(:user) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Criado por não pode ficar em branco')
      end
    end
  end
end
