# frozen_string_literal: true

module V1
  #
  # Lending business related interface api
  #
  # @author hubery.cui
  #
  class BorrowAPI < Grape::API
    namespace :borrow do
      extend ActiveSupport::Concern

      #
      # Borrow books
      # @api /api/v1/borrow/create_borrow_book_order
      #
      # @author hubery.cui
      #
      #
      desc 'Borrow books', entity: ::V1::Entities::Order::Info, summary: 'Create a loan book order'
      params do
        requires :user_id, type: Integer, allow_blank: false, desc: 'need borrow user id'
        requires :book_id, type: Integer, allow_blank: false, desc: 'borrowed book id'
        optional :borrowed_at, type: String, desc: 'books borrowed time'
        optional :estimated_return_time, type: String, desc: 'books estimated return time'
      end
      post :create_borrow_book_order do
        command = ::V1::Borrow::BorrowBookCommand.run(params)
        render_std(command)
      rescue => e
        render_failed(command, { code: ResponseCode::CMD_VALIDATE_REQUIRED_ERROR, message: e.message })
      end
    end
  end
end
