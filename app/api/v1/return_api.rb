# frozen_string_literal: true

module V1
  #
  # return business related interface api
  #
  # @author hubery.cui
  #
  class ReturnAPI < Grape::API
    namespace :return do
      extend ActiveSupport::Concern

      #
      # return books
      # @api /api/v1/return/return_book
      #
      # @author hubery.cui
      #
      #
      desc 'return books', entity: ::V1::Entities::Order::Info, summary: 'return book order'
      params do
        requires :user_id, type: Integer, allow_blank: false, desc: 'need borrow user id'
        optional :order_id, type: Integer, allow_blank: true, desc: 'borrowed order id'
        requires :book_id, type: Integer, allow_blank: false, desc: 'borrowed book id'
      end
      post :return_book do
        command = ::V1::Return::ReturnBookCommand.run(params)
        render_std(command)
      rescue ::V1::Return::ReturnBookCommandError, ::ApplicationCommandError => e
        render_failed(command, { code: ResponseCode::CMD_VALIDATE_REQUIRED_ERROR, message: e.message })
      end
    end
  end
end
