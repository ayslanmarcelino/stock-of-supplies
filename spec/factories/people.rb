FactoryBot.define do
  factory :person do
    association :address
    association :enterprise

    trait :person do
      name { FFaker::NameBR.name }
      nickname { FFaker::NameBR.first_name }
      document_number { CPF.generate }
      cell_number { FFaker.numerify('###########') }
      telephone_number { FFaker.numerify('##########') }
      identity_document_type { ['rne', 'rg'].sample }
      identity_document_number { FFaker.numerify('#########') }
      identity_document_issuing_agency { 'SSP' }
      marital_status { :single }
      birth_date { Date.today - 18.years }
      kind { :person }
    end

    trait :company do
      name { FFaker::Company.name }
      trade_name { FFaker::Company.name }
      document_number { CNPJ.generate }
      cell_number { FFaker.numerify('###########') }
      telephone_number { FFaker.numerify('##########') }
      kind { :company }
    end
  end
end
