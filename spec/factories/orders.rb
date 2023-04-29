FactoryBot.define do
  factory :order do
    amount { rand(1..100) }
    created_by { create(:user, :with_person) }
    requesting_unit { create(:unit) }

    association :stock

    trait :pending do
      status { :pending }
    end

    trait :approved do
      status { :approved }
      approved_by { create(:user, :with_person) }
    end

    trait :rejected do
      status { :rejected }
      rejected_by { create(:user, :with_person) }
    end

    trait :delivered do
      status { :delivered }
      delivered_by { create(:user, :with_person) }
    end
  end
end
