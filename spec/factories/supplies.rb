FactoryBot.define do
  factory :supply do
    name { SecureRandom.base64 }
    created_by { create(:user, :with_person) }
  end
end
