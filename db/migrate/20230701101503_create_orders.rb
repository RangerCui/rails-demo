# frozen_string_literal: true
class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :account_id, null: false, comment: 'related account id'
      t.integer :status, null: false, comment: 'order status'
      t.integer :book_id, null: false, comment: 'related book id'
      t.datetime :borrowed_at, comment: 'books borrowed time'
      t.datetime :estimated_return_time, comment: 'books estimated time of return'
      t.datetime :actual_return_time, comment: 'Books actually return to time'
      t.float :amount, null: false, default: 0, comment: 'amount paid'

      t.timestamps
    end
  end
end
