class CreateMonthlySummaries < ActiveRecord::Migration[6.1]
  def change
    create_table :monthly_summaries do |t|
      t.integer :account_id, null: false, comment: 'related account id'
      t.integer :month, null: false, comment: 'month'
      t.integer :year, null: false, comment: 'year'
      t.float :amount_spent, null: false, default: 0.0, comment: 'amount spent'
      t.integer :number_of_borrow, null: false, default: 0, comment: 'user number of borrow on a month'

      t.timestamps
    end
  end
end
