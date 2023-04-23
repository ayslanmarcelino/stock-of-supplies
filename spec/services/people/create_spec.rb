require 'rails_helper'

RSpec.describe People::Create, type: :service do
  subject { described_class.new(params: params, enterprise: enterprise) }

  let(:enterprise) { create(:enterprise) }
  let(:params) do
    {
      representative_document_number: CPF.generate,
      representative_name: Faker::Name.name,
      birth_date: Date.today - 18.years,
      cell_number: FFaker.numerify('###########'),
      telephone_number: FFaker.numerify('##########'),
      identity_document_issuing_agency: 'SSP',
      identity_document_number: FFaker.numerify('#########'),
      identity_document_type: ['rne', 'rg'].sample
    }
  end

  describe '#call' do
    context 'when the person does not already exist' do
      it 'creates a new person' do
        expect do
          subject.call
        end.to change { Person.count }.by(1)
      end

      it 'sets the attributes correctly' do
        person = subject.call

        expect(person.document_number).to eq(params[:representative_document_number])
        expect(person.name).to eq(params[:representative_name])
        expect(person.birth_date).to eq(params[:birth_date])
        expect(person.cell_number).to eq(params[:cell_number])
        expect(person.telephone_number).to eq(params[:telephone_number])
        expect(person.identity_document_issuing_agency).to eq(params[:identity_document_issuing_agency])
        expect(person.identity_document_number).to eq(params[:identity_document_number])
        expect(person.identity_document_type).to eq(params[:identity_document_type])
        expect(person.enterprise).to eq(enterprise)
      end

      it 'returns the new person' do
        person = subject.call

        expect(person).to be_a(Person)
        expect(person).to be_persisted
      end
    end

    context 'when the person already exists' do
      let!(:existing_person) do
        create(
          :person,
          document_number: params[:representative_document_number],
          name: params[:representative_name],
          enterprise: enterprise
        )
      end

      it 'does not create a new person' do
        expect do
          subject.call
        end.not_to change { Person.count }
      end

      it 'returns the existing person' do
        person = subject.call

        expect(person).to eq(existing_person)
      end
    end
  end
end
