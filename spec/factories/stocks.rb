FactoryBot.define do
  factory :stock do
    amount { rand(0..10) }
    kind_cd { [:input, :output].sample }
    supply { create(:supply) }
    unit { create(:unit) }
  end
end
