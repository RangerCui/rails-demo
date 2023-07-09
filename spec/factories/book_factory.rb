FactoryBot.define do
  factory :book, class: 'Book' do
    id { 1 }
    name { 'rspec_book' }
    author { 'Stephen William Hawking' }
    inventory { 10 }
  end
end
