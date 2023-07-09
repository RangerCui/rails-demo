# frozen_string_literal: true

# == Schema Information
#
# Table name: hot_books
#
#  id                   :bigint           not null, primary key
#  author(book author)  :string(255)      default(""), not null
#  inventory(inventory) :integer          default(0), not null
#  name(book name)      :string(255)      default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class HotBook < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------
  has_many :daily_profits, foreign_key: 'book_id'
  has_many :orders, foreign_key: 'book_id'

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------

end
