# frozen_string_literal: true

# == Schema Information
#
# Table name: daily_profits
#
#  id                                :bigint           not null, primary key
#  amount(book profit amount)        :float(24)        default(0.0), not null
#  borrowed_day(books borrowed date) :datetime
#  day(related book id)              :integer          not null
#  month(related book id)            :integer          not null
#  year(related book id)             :integer          not null
#  created_at                        :datetime         not null
#  updated_at                        :datetime         not null
#  book_id(related book id)          :integer          not null
#
#
class DailyProfit < ApplicationRecord
  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------
  belongs_to :book

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------
end
