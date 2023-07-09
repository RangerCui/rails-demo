class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :name, null: false, default: '', comment: 'user name'
      t.string :email, null: false, default: '', comment: 'email'
      t.integer :phone, null: false, default: 0, comment: 'phone'

      t.timestamps
    end
  end
end
