# frozen_string_literal: true
p 'begin'

user_data = [
  { name: 'Bob', email: 'bob@gamil.com', phone: 123 },
  { name: 'Bill', email: 'bill@gamil.com', phone: 123 }
]
User.create!(user_data)

account_data = [
  { user_id: 1, status: 1, balance: rand(30..100) },
  { user_id: 2, status: 1, balance: rand(30..100) }
]
Account.create!(account_data)

book_data = [
  { name: 'A Brief History of Time: from the Big Bang to Black Holes', author: 'Stephen William Hawking', inventory: 10 },
  { name: 'Star Trek', author: 'Eugene Wesley Roddenberry', inventory: 10 }
]
Book.create!(book_data)

p 'deal end'
