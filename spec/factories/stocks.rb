FactoryBot.define do
  factory :stock do
    amount { rand(1..10) }
    kind_cd { :input }
    reason { 'Recebido pelo Estado' }
    source { create(:batch) }
    supply { batch.supply }
    created_by { create(:user) }
    expiration_date { Date.current + 5.years }
    occurrence_date { Date.current - 2.days }
    unit { create(:unit) }
    batch { create(:batch) }
  end
end
