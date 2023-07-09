# == Schema Information
#
# Table name: accounts
#
#  id                       :bigint           not null, primary key
#  balance(balance)         :float(24)        default(0.0), not null
#  status(account status)   :integer          default(0), not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  user_id(related user id) :integer          default(0), not null
#
class Account < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------
  MINIMUM_BALANCE = 0

  # ------------------------------------------ enumeration definition ---------------------------------
  enum status: { unactivated: 0, activated: 1, locked: 2 }

  # ------------------------------------------ relevance relation -------------------------------------
  has_many :orders
  has_many :monthly_summaries
  has_many :annual_summaries

  belongs_to :user

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------
end
