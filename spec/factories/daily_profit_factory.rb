FactoryBot.define do
  factory :daily_profit, class: 'DailyProfit' do
    id { 1 }
    amount { 100.0 }
    day { 8 }
    month { 7 }
    year { 2023 }
    created_at { '2023-07-09 23:49:52 +0800' }
    association :book


    trait :last_two_day do
      id { 2 }
      created_at { '2023-07-07 23:49:52 +0800' }
      day { 7 }
    end
  end
end
