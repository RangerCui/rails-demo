# frozen_string_literal: true

# == Schema Information
#
# Table name: books
#
#  id                   :bigint           not null, primary key
#  author(book author)  :string(255)      default(""), not null
#  inventory(inventory) :integer          default(0), not null
#  name(book name)      :string(255)      default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
class Book < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------
  has_many :daily_profits
  has_many :orders

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------

end
