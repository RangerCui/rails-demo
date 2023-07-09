# frozen_string_literal: true

module V1
  module User

    module Info

      class SearchCommandError < StandardError; end

      #
      # user details query command
      # @author hubery.cui
      #
      class SearchCommand < ApplicationCommand
        attribute :user_id, required: true

        #
        # main method
        #
        #
        # @return [Object] user
        #
        def perform
          user = ::User.find_by_id user_id
          { user_info: user, account_info: user&.account, order_info: user&.account&.orders }
        end
      end
    end
  end
end
