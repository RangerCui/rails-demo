# == Schema Information
#
# Table name: monthly_summaries
#
#  id                                                 :bigint           not null, primary key
#  amount_spent(amount spent)                         :float(24)        default(0.0), not null
#  month(month)                                       :integer          not null
#  year(year)                                         :integer          not null
#  number_of_borrow(user number of borrow on a month) :integer          not null
#  created_at                                         :datetime         not null
#  updated_at                                         :datetime         not null
#  account_id(related account id)                     :integer          not null
#
class MonthlySummary < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------
end
