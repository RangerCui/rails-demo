# frozen_string_literal: true

class CreateDailyProfits < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_profits do |t|
      t.integer :book_id, null: false, comment: 'related book id'
      t.integer :year, null: false, comment: 'related book id'
      t.integer :month, null: false, comment: 'related book id'
      t.integer :day, null: false, comment: 'related book id'
      t.datetime :borrowed_day, comment: 'books borrowed date'
      t.float :amount, null: false, default: 0, comment: 'book profit amount'

      t.timestamps
    end
  end
end
