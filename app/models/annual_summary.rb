# == Schema Information
#
# Table name: annual_summaries
#
#  id                                                :bigint           not null, primary key
#  amount_spent(amount spent)                        :float(24)        default(0.0), not null
#  number_of_borrow(user number of borrow on a year) :integer          not null
#  year(year)                                        :integer          not null
#  created_at                                        :datetime         not null
#  updated_at                                        :datetime         not null
#  account_id(related user id)                          :integer          not null
#
class AnnualSummary < ApplicationRecord
  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------
end
