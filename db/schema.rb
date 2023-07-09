# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_07_05_042819) do

  create_table "accounts", charset: "utf8mb3", force: :cascade do |t|
    t.integer "status", default: 0, null: false, comment: "account status"
    t.float "balance", default: 0.0, null: false, comment: "balance"
    t.integer "user_id", default: 0, null: false, comment: "related user id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "annual_summaries", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "related user id"
    t.integer "year", null: false, comment: "year"
    t.float "amount_spent", default: 0.0, null: false, comment: "amount spent"
    t.integer "number_of_borrow", default: 0, null: false, comment: "user number of borrow on a year"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "books", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", default: "", null: false, comment: "book name"
    t.string "author", default: "", null: false, comment: "book author"
    t.integer "inventory", default: 0, null: false, comment: "inventory"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "daily_profits", charset: "utf8mb3", force: :cascade do |t|
    t.integer "book_id", null: false, comment: "related book id"
    t.integer "year", null: false, comment: "related book id"
    t.integer "month", null: false, comment: "related book id"
    t.integer "day", null: false, comment: "related book id"
    t.datetime "borrowed_day", comment: "books borrowed date"
    t.float "amount", default: 0.0, null: false, comment: "book profit amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dev_samples", charset: "utf8mb3", comment: "示例用表", force: :cascade do |t|
    t.string "title", comment: "示例标题"
    t.string "content", comment: "示例正文"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "hot_books", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", default: "", null: false, comment: "book name"
    t.string "author", default: "", null: false, comment: "book author"
    t.integer "inventory", default: 0, null: false, comment: "inventory"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "monthly_summaries", charset: "utf8mb3", force: :cascade do |t|
    t.integer "user_id", null: false, comment: "related user id"
    t.integer "month", null: false, comment: "month"
    t.integer "year", null: false, comment: "year"
    t.float "amount_spent", default: 0.0, null: false, comment: "amount spent"
    t.integer "number_of_borrow", null: false, comment: "user number of borrow on a month"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "orders", charset: "utf8mb3", force: :cascade do |t|
    t.integer "account_id", null: false, comment: "related account id"
    t.integer "status", null: false, comment: "order status"
    t.integer "book_id", null: false, comment: "related book id"
    t.datetime "borrowed_at", comment: "books borrowed time"
    t.datetime "estimated_return_time", comment: "books estimated time of return"
    t.datetime "actual_return_time", comment: "Books actually return to time"
    t.float "amount", default: 0.0, null: false, comment: "amount paid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", default: "", null: false, comment: "user name"
    t.string "email", default: "", null: false, comment: "email"
    t.integer "phone", default: 0, null: false, comment: "phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
