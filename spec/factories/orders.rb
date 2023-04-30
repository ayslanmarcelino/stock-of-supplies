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
      approved_by { create(:user, :with_person) }
      approval_date { Time.current }
    end

    trait :rejected do
      aasm_state { :rejected }
      rejected_by { create(:user, :with_person) }
      reason { 'Suprimentos venceram' }
      rejection_date { Time.current }
    end

    trait :delivered do
      aasm_state { :delivered }
      delivered_by { create(:user, :with_person) }
      delivery_date { Time.current }
      approved_by { create(:user, :with_person) }
      approval_date { Time.current }
    end
  end
end
