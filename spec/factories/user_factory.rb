FactoryBot.define do
  factory :user, class: 'User' do
    id { 1 }
    name { 'rspec_user_name' }
    email { 'respec_email@gamil.com' }
    phone { '123' }

    trait :rspec_user_name2 do
      id { 2 }
      name { 'rspec_user_name2' }
      email { 'respec_email22@gamil.com' }
      phone { '123222' }
    end
  end
end
