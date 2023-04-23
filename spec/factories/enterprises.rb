FactoryBot.define do
  factory :enterprise do
    email { FFaker::Internet.email }
    document_number { CNPJ.generate }
    name { FFaker::Company.name }
    trade_name { FFaker::Company.name }
    representative_name { FFaker::NameBR.name }
    representative_document_number { CPF.generate }
    opening_date { Date.today - 30 }
    birth_date { Date.today - 18.years }
    cell_number { FFaker.numerify('###########') }
    identity_document_issuing_agency { 'SSP' }
    identity_document_number { FFaker.numerify('#########') }
    identity_document_type { 'rg' }
    telephone_number { FFaker.numerify('##########') }

    association :address
  end
end
