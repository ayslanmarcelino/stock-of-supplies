FactoryBot.define do
  factory :stock do
    amount { rand(1..10) }
    kind_cd { :input }
    reason { 'Recebido pelo governo' }
    source { create(:batch) }
    supply { batch.supply }
    created_by { create(:user) }
    expiration_date { Date.current + 5.years }
    unit { create(:unit) }
  end
end
