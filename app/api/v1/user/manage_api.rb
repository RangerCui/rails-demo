# frozen_string_literal: true

module V1
  module User

    #
    # User management API
    #
    # @author hubery.cui
    #
    module ManageAPI
      extend ActiveSupport::Concern

      included do
        #
        # Set the user account amount
        # @api /api/v1/user/manage/set_user_amount
        #
        # @author hubery.cui
        #
        #
        desc 'Set the user account amount', entity: ::V1::Entities::User::Info, summary: 'user info'
        params do
          requires :user_id, type: Integer, allow_blank: false, desc: 'need set user id'
          requires :balance, type: Float, allow_blank: false, desc: 'need set user balance'
        end
        post :set_user_amount do
          render_std(::V1::User::Manage::SetUserAmountCommand.run(params))
        end
      end
    end
  end
end
