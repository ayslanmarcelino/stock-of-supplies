FactoryBot.define do
  factory :unit do
    email { FFaker::Internet.email }
    cnes_number { FFaker.numerify('#######') }
    kind_cd { :pni }
    name { FFaker::Company.name }
    representative_name { FFaker::NameBR.name }
    representative_document_number { CPF.generate }
    representative_cns_number { FFaker.numerify('#######') }
    birth_date { Date.today - 18.years }
    cell_number { FFaker.numerify('###########') }
    identity_document_issuing_agency { 'SSP' }
    identity_document_number { FFaker.numerify('#########') }
    identity_document_type { 'rg' }
    telephone_number { FFaker.numerify('##########') }

    association :address
  end
end
