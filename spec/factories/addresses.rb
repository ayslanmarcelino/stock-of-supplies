FactoryBot.define do
  factory(:address) do
    street       { FFaker::AddressBR.street }
    number       { FFaker.numerify('###') }
    neighborhood { FFaker::AddressBR.neighborhood }
    state        { FFaker::AddressBR.state_abbr }
    city         { FFaker::AddressBR.city }
    zip_code     { FFaker::AddressBR.zip_code }
    country      { 'Brasil' }
    complement   { FFaker::AddressBR.complement }

    trait :empty do
      street {}
      number {}
      neighborhood {}
      city {}
      state {}
      zip_code {}
      country {}
      complement {}
    end
  end
end
