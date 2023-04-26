FactoryBot.define do
  factory :stock do
    amount { rand(1..10) }
    kind_cd { :input }
    reason { 'Recebido pelo governo' }
    supply { create(:supply) }
    created_by { create(:user) }
    unit { create(:unit) }
  end
end
