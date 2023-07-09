class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.integer :status, null: false, default: 0, comment: 'account status'
      t.float :balance, null: false, default: 0, comment: 'balance'
      t.integer :user_id, null: false, default: 0, comment: 'related user id'

      t.timestamps
    end
  end
end
