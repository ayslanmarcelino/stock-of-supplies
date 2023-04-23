# == Schema Information
#
# Table name: enterprises
#
#  id                               :bigint           not null, primary key
#  active                           :boolean          default(TRUE)
#  birth_date                       :date
#  cell_number                      :string
#  document_number                  :string
#  email                            :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  name                             :string
#  opening_date                     :date
#  representative_document_number   :string
#  representative_name              :string
#  telephone_number                 :string
#  trade_name                       :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#
# Indexes
#
#  index_enterprises_on_address_id  (address_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#
require 'rails_helper'

RSpec.describe Enterprise, type: :model do
  subject do
    described_class.new(
      document_number: document_number,
      email: email,
      name: name,
      representative_name: representative_name,
      representative_document_number: representative_document_number
    )
  end

  let(:document_number) { CNPJ.generate }
  let(:email) { FFaker::Internet.email }
  let(:name) { FFaker::NameBR.name }
  let(:representative_name) { FFaker::NameBR.name }
  let(:representative_document_number) { CPF.generate }

  context 'when sucessful' do
    context 'when valid params' do
      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsucessful' do
    context 'when has enterprise with existing document_number' do
      let!(:enterprise) { create(:enterprise, document_number: document_number) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNPJ já está em uso')
      end
    end

    context 'when dont pass a email' do
      let(:email) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('E-mail não pode ficar em branco')
      end
    end

    context 'when dont pass a document_number' do
      let(:document_number) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNPJ não pode ficar em branco')
      end
    end

    context 'when dont pass a name' do
      let(:name) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Razão Social não pode ficar em branco')
      end
    end

    context 'when dont pass a representative_name' do
      let(:representative_name) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Nome completo não pode ficar em branco')
      end
    end

    context 'when dont pass a representative_document_number' do
      let(:representative_document_number) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CPF não pode ficar em branco')
      end
    end
  end
end
