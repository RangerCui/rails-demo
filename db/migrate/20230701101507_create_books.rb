class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.string :name, null: false, default: '', comment: 'book name'
      t.string :author, null: false, default: '', comment: 'book author'
      t.integer :inventory, null: false, default: 0, comment: 'inventory'

      t.timestamps
    end
  end
end
