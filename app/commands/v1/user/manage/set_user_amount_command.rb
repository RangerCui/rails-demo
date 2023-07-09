# frozen_string_literal: true

module V1
  module User

    module Manage

      class SetUserAmountCommandError < StandardError; end

      #
      # Set the user account balance command
      # @author hubery.cui
      #
      class SetUserAmountCommand < ApplicationCommand
        attribute :user_id, required: true
        attribute :balance, required: true

        #
        # main method
        #
        #
        # @return [Object] user
        #
        def perform
          user = ::User.find_by_id user_id
          user.account.update(balance: balance)
          user
        end
      end
    end
  end
end
