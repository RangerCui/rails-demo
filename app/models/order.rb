# frozen_string_literal: true

# == Schema Information
#
# Table name: orders
#
#  id                                                    :bigint           not null, primary key
#  actual_return_time(Books actually return to time)     :datetime
#  amount(amount paid)                                   :float(24)        default(0.0), not null
#  borrowed_at(books borrowed time)                      :datetime
#  estimated_return_time(books estimated time of return) :datetime
#  status(order status)                                  :integer          not null
#  created_at                                            :datetime         not null
#  updated_at                                            :datetime         not null
#  account_id(related account id)                        :integer          not null
#  book_id(related book id)                              :integer          not null
#
class Order < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------
  enum status: { borrowed: 0, returned: 1, overdue: 2 }

  # ------------------------------------------ relevance relation -------------------------------------
  belongs_to :account
  belongs_to :book

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------
end
