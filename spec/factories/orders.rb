FactoryBot.define do
  factory :order do
    amount { rand(1..100) }
    created_by { create(:user, :with_person) }
    requesting_unit { create(:unit) }

    association :stock

    trait :pending do
      aasm_state { :pending }
    end

    trait :approved do
      aasm_state { :approved }
    end

    trait :rejected do
      aasm_state { :rejected }
      reason { 'Suprimentos venceram' }
    end

    trait :delivered do
      aasm_state { :delivered }
    end
  end
end
