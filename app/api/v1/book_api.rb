# frozen_string_literal: true

module V1
  #
  # Book service related interface api
  #
  # @author hubery.cui
  #
  class BookAPI < Grape::API
    namespace :book do
      extend ActiveSupport::Concern

      #
      # search book detail
      # @api /api/v1/book/search_book_income
      #
      # @author hubery.cui
      #
      #
      desc 'search book income'
      params do
        requires :book_id, type: Integer, allow_blank: false, desc: 'need search book id'
        optional :start_time, type: String, desc: 'search start time'
        optional :end_time, type: String, desc: 'search end time'
      end
      get :search_book_income do
        command = ::V1::Book::SearchCommand.run(params)
        render_std(command)
      rescue ::V1::Book::SearchCommandError, ::ApplicationCommandError => e
        render_failed(command, { code: ResponseCode::CMD_VALIDATE_REQUIRED_ERROR, message: e.message })
      end
    end
  end
end
