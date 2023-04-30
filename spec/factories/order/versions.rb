FactoryBot.define do
  factory :order_version, class: 'Order::Version' do
    aasm_state { :pending }
    order { create(:order) }
    responsible { create(:user, :with_person) }
  end
end
