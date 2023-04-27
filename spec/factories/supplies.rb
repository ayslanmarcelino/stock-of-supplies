FactoryBot.define do
  factory :supply do
    name { SecureRandom }
    created_by { create(:user, :with_person) }
  end
end
