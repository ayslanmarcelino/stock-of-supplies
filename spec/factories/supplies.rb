FactoryBot.define do
  factory :supply do
    name { 'Omalizumabe' }
    created_by { create(:user, :with_person) }
  end
end
