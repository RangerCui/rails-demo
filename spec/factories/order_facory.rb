FactoryBot.define do
  factory :order, class: 'Order' do
    id { 1 }
    amount { 1 }
    borrowed_at { '2023-07-09 23:59:52 +0800' }
    status { 0 }
    created_at { '2023-07-09 22:59:52 +0800' }
    association :account
    association :book

    trait :have_estimated_return_time do
      estimated_return_time { Time.now }
    end

    trait :last_three_day do
      id { 2 }
      borrowed_at { '2023-07-06 23:59:52 +0800' }
      created_at { '2023-07-06 22:19:52 +0800' }
    end
  end
end
