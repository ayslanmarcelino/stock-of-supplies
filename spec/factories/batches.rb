FactoryBot.define do
  factory :batch do
    identifier { SecureRandom.base36 }
    arrived_date { Date.current }
    expiration_date { Date.current + 1.month }
    amount { rand(1..100) }
    remaining { amount }
    supply { create(:supply) }
    created_by { create(:user, :with_person) }
    unit { create(:unit) }
  end
end
