# frozen_string_literal: true

module V1
  module User

    #
    # User management API
    #
    # @author hubery.cui
    #
    module InfoAPI
      extend ActiveSupport::Concern

      included do
        #
        # search user info
        # @api /api/v1/user/info/search
        #
        # @author hubery.cui
        #
        #
        desc 'search user info', entity: ::V1::Entities::User::UserDetailInfo, summary: 'user info'
        params do
          requires :user_id, type: Integer, allow_blank: false, desc: 'need search user id'
        end
        get :search do
          render_std(::V1::User::Info::SearchCommand.run(params))
        end
      end
    end
  end
end
