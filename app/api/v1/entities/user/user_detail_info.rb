# frozen_string_literal: true

module V1
  module Entities
    module User
      #
      # user detail info Entity
      #
      # @author hubery.cui
      #
      class UserDetailInfo < ApplicationEntity
        expose :user_info, using: ::V1::Entities::User::Info, documentation: { type: 'Hash', desc: 'user base info' }
        expose :account_info, using: ::V1::Entities::Account::Info, documentation: { type: 'Hash', desc: 'user account base info' }
        expose :order_info, using: ::V1::Entities::Order::Info, documentation: { type: 'Array', desc: 'user orders base info' }
      end
    end
  end
end
