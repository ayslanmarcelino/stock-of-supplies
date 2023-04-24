FactoryBot.define do
  factory :person do
    name { FFaker::NameBR.name }
    cns_number { FFaker.numerify('#######') }
    nickname { FFaker::NameBR.first_name }
    document_number { CPF.generate }
    cell_number { FFaker.numerify('###########') }
    telephone_number { FFaker.numerify('##########') }
    identity_document_type { ['rne', 'rg'].sample }
    identity_document_number { FFaker.numerify('#########') }
    identity_document_issuing_agency { 'SSP' }
    marital_status { :single }
    birth_date { Date.today - 18.years }

    association :address
    association :unit
  end
end
