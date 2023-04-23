FactoryBot.define do
  factory(:user) do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    active { true }

    trait :with_person do
      before :create do |resource|
        resource.person = create(:person, :person, owner: resource)
      end
    end
  end
end
