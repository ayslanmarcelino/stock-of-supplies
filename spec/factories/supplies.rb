FactoryBot.define do
  factory :supply do
    name { Faker::Company.name }
    created_by { create(:user, :with_person) }
  end
end
