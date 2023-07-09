FactoryBot.define do
  factory :account, class: 'Account' do
    status { 1 }
    balance { 40 }
    association :user

    trait :no_balance do
      id { 2 }
      status { 1 }
      balance { 0 }
      user  { association :user, :rspec_user_name2 }
    end
  end
end
