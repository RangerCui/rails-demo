# frozen_string_literal: true

module V1
  module Book

    class SearchCommandError < StandardError; end

    #
    # Book details query command
    # @author hubery.cui
    #
    class SearchCommand < ApplicationCommand
      attribute :book_id, required: true
      attribute :start_time, required: false
      attribute :end_time, required: false

      #
      # main method
      #
      #
      # @return [Object] user
      #
      def perform
        # query book
        find_book

        # compote book amount
        compute_book_amount
      end

      #
      # Calculate the cost of books over time
      #
      # @return [Float]  return book amount
      #
      def compute_book_amount
        daily_profits, orders = deal_query_time(start_time, end_time)
        daily_profits_amount = daily_profits.sum(:amount)
        orders_amount = orders.sum(&:amount) rescue 0
        daily_profits_amount + orders_amount
      end

      #
      # Query the corresponding data based on the incoming time
      #
      # @param [String] start_time   Query start time
      # @param [String] end_time     Query end time
      #
      # @return [Array][Object]     Returns an array of objects for daily_profits and orders
      #
      def deal_query_time(start_time = nil, end_time = nil)
        order = Order.where(book_id: @book.id).select('id').limit(1).exists?
        return [DailyProfit.none, Order.none] if order.blank?

        daily_profits = @book.daily_profits
        orders = Order.none

        start_time_end_of_the_day = start_time.present? ? start_time.to_time.end_of_day : nil
        end_time_of_the_day = end_time.present? ? end_time.to_time.beginning_of_day : nil
        # The unilateral time is null
        if start_time.present? && end_time.blank?
          orders = @book.orders.where('created_at between ? and ?', start_time.to_time, start_time_end_of_the_day)
          daily_profits = daily_profits.where('created_at >= ?', start_time_end_of_the_day)
        elsif end_time.present? && start_time.blank?
          orders = @book.orders.where('created_at between ? and ?', end_time_of_the_day, end_time.to_time)
          daily_profits = daily_profits.where('created_at <= ?', end_time_of_the_day)
        elsif start_time.present? && end_time.present?
          # Determine whether the two times are on the same day or adjacent days
          daily_profits = if start_time.to_date == end_time.to_date || (start_time.to_date - end_time.to_date).abs == 1
                            # binding.pry
                            DailyProfit.none
                          else
                            daily_profits.where('created_at between ? and ?', start_time_end_of_the_day, end_time_of_the_day)
                          end
          start_orders = @book.orders.where('created_at between ? and ?', end_time_of_the_day, end_time.to_time)
          end_orders = @book.orders.where('created_at between ? and ?', start_time.to_time, start_time_end_of_the_day)
          orders = start_orders + end_orders
        end
        [daily_profits, orders.uniq]
      end

    end
  end
end
