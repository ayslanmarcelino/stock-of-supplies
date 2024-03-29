# == Schema Information
#
# Table name: units
#
#  id                               :bigint           not null, primary key
#  active                           :boolean          default(TRUE)
#  birth_date                       :date
#  cell_number                      :string
#  cnes_number                      :string
#  email                            :string
#  identity_document_issuing_agency :string
#  identity_document_number         :string
#  identity_document_type           :string
#  kind_cd                          :string
#  name                             :string
#  representative_cns_number        :string
#  representative_document_number   :string
#  representative_name              :string
#  telephone_number                 :string
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  address_id                       :bigint
#  created_by_id                    :bigint
#
# Indexes
#
#  index_units_on_address_id     (address_id)
#  index_units_on_created_by_id  (created_by_id)
#
# Foreign Keys
#
#  fk_rails_...  (address_id => addresses.id)
#  fk_rails_...  (created_by_id => users.id)
#
require 'rails_helper'

RSpec.describe Unit, type: :model do
  subject do
    described_class.new(
      cnes_number: cnes_number,
      email: email,
      name: name,
      representative_name: representative_name,
      representative_document_number: representative_document_number,
      representative_cns_number: representative_cns_number,
      kind: kind,
      created_by: created_by
    )
  end

  let(:cnes_number) { FFaker.numerify('#######') }
  let(:email) { FFaker::Internet.email }
  let(:name) { FFaker::NameBR.name }
  let(:representative_name) { FFaker::NameBR.name }
  let(:representative_document_number) { CPF.generate }
  let(:kind) { Unit::KINDS.map { |array| array.second }.sample }
  let(:representative_cns_number) { FFaker.numerify('###############') }
  let(:created_by) { create(:user) }

  context 'when sucessful' do
    context 'when valid params' do
      it do
        expect(subject).to be_valid
      end
    end
  end

  context 'when unsucessful' do
    context 'when param is invalid' do
      context 'when representative_document_number' do
        let!(:representative_document_number) { '12345678912' }

        it do
          expect(subject).not_to be_valid
          expect(subject.errors.full_messages.to_sentence).to eq('CPF não é válido')
        end
      end
    end

    context 'when has unit with existing cnes_number' do
      let!(:unit) { create(:unit, cnes_number: cnes_number) }

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNES já está em uso')
      end
    end

    context 'when dont pass a email' do
      let(:email) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('E-mail não pode ficar em branco')
      end
    end

    context 'when dont pass a kind' do
      let(:kind) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Tipo não pode ficar em branco')
      end
    end

    context 'when dont pass a cnes_number' do
      let(:cnes_number) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNES não pode ficar em branco and CNES deve ter 7 caracteres')
      end
    end

    context 'when dont pass a name' do
      let(:name) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('Nome não pode ficar em branco')
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

    context 'when dont pass a representative_cns_number' do
      let(:representative_cns_number) {}

      it do
        expect(subject).not_to be_valid
        expect(subject.errors.full_messages.to_sentence).to eq('CNS não pode ficar em branco and CNS deve ter 15 caracteres')
      end
    end
  end
end
