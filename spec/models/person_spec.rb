# == Schema Information
#
# Table name: people
#
#  id                               :bigint           not null, primary key
#  birth_date                       :date
#  cell_number                      :string
#  document_number                  :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  kind_cd                          :string
#  marital_status_cd                :string
#  name                             :string
#  nickname                         :string
#  owner_type                       :string
#  telephone_number                 :string
#  trade_name                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#  enterprise_id                    :bigint
#  owner_id                         :bigint
#
# Indexes
#
#  index_people_on_address_id     (address_id)
#  index_people_on_enterprise_id  (enterprise_id)
#  index_people_on_owner          (owner_type,owner_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (enterprise_id => enterprises.id)
#
require 'rails_helper'

RSpec.describe Person, type: :model do
  subject { described_class.new(document_number: document_number, name: name, owner: owner, enterprise: enterprise) }

  let!(:document_number) { CNPJ.generate }
  let!(:name) { Faker::Name.name }
  let!(:owner) { create(:user) }
  let!(:enterprise) { create(:enterprise) }

  context 'when sucessful' do
    context 'when has person with same document_number' do
      let!(:person) { create(:person, :person, document_number: document_number) }

      context 'when does not have same enterprise' do
        let!(:enterprise) { create(:enterprise) }

        it do
          expect(subject).to be_valid
        end
      end

      context 'when does not have same owner' do
        let!(:owner) { create(:address) }

        it do
          expect(subject).to be_valid
        end
      end
    end

    context 'when does not have same document_number, same owner and same enterprise' do
      let!(:document_number) { CNPJ.generate }
      let!(:owner) { create(:address) }
      let!(:enterprise) { create(:enterprise) }

      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsucessful' do
    context 'when has person with same document_number, enterprise and owner' do
      let!(:person) { create(:person, :person, document_number: document_number, enterprise: enterprise, owner: owner) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CPF já está em uso')
      end
    end

    context 'when do not pass document_number' do
      let(:document_number) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CPF não pode ficar em branco')
      end
    end

    context 'when do not pass name' do
      let(:name) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Nome completo não pode ficar em branco')
      end
    end
  end
end
