# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email(email)    :string(255)      default(""), not null
#  name(user name) :string(255)      default(""), not null
#  phone(phone)    :integer          default(0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord

  # ------------------------------------------ model check --------------------------------------------

  # ------------------------------------------ constant definition ------------------------------------

  # ------------------------------------------ enumeration definition ---------------------------------

  # ------------------------------------------ relevance relation -------------------------------------
  has_one :account, foreign_key: :user_id

  has_many :orders

  # ------------------------------------------ scope --------------------------------------------------

  # ------------------------------------------ callback -----------------------------------------------

end
