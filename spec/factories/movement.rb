FactoryBot.define do
  factory :movement do
    amount { rand(1..10) }
    kind_cd { :input }
    reason { 'Recebido pelo Estado' }
    source { create(:stock) }
    supply { stock.supply }
    created_by { create(:user) }
    expiration_date { Date.current + 5.years }
    occurrence_date { Date.current - 2.days }
    unit { create(:unit) }
    stock { create(:stock) }
  end
end
