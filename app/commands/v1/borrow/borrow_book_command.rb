# frozen_string_literal: true

module V1
  module Borrow

    class BorrowBookCommandError < StandardError; end

    # 借书流程，先查询redis中是否有数据，没有数据，查询数据库，将数据库中的数据，写入到redis中，redis 中的数据结构为： { inventory: 10, is_hot_book: false, borrowed_times: 0 }
    # 借书完，更新redis数据，超过10次，当天，则将数据写入一份进入到hot_book，后面查询book数据都会进行拆分查询

    #
    # Borrow book command
    # @author hubery.cui
    #
    class BorrowBookCommand < ApplicationCommand

      attribute :user_id, required: true
      attribute :book_id, required: true
      attribute :borrowed_at, required: false
      attribute :estimated_return_time, required: false

      DEFAULT_AMOUNT = 1
      HOT_LIMIT = 10

      #
      # main method
      #
      #
      #
      def perform
        data_check
        create_related_data
      end

      #
      # base data check
      #
      # @return [Object] return the account objects
      #
      def data_check
        super
        check_book_inventory
        raise BorrowBookCommandError, 'Insufficient account balance' if @account.balance.zero?

        @account
      end

      #
      # create book lending linked data
      #
      #
      #
      def create_related_data
        current_time = Time.now
        borrowed_at ||= current_time
        ActiveRecord::Base.transaction do
          # create order
          if borrowed_at.present? && estimated_return_time.present?
            amount = compute_amount(Date.parse(borrowed_at.to_s), Date.parse(estimated_return_time.to_s))
          end
          amount ||= DEFAULT_AMOUNT
          order = Order.create({
                                 account_id: @account.id,
                                 book_id: book_id,
                                 status: ::Order.statuses['borrowed'],
                                 borrowed_at: borrowed_at,
                                 estimated_return_time: estimated_return_time,
                                 amount: amount
                               })
          # create or update daily profit data
          daily_profit = DailyProfit.find_or_initialize_by({
                                                             year: current_time.year, month: current_time.month,
                                                             day: current_time.day, book_id: @book.id
                                                           })
          daily_profit.update(amount: daily_profit.amount + amount)
          # calculate monthly data
          monthly_summary = MonthlySummary.find_or_initialize_by(
            user_id: @user.id,
            month: current_time.month,
            year: current_time.year
          )
          amount_spent = monthly_summary.amount_spent || 0
          number_of_borrow = monthly_summary.number_of_borrow || 0
          monthly_summary.update({
                                   amount_spent: amount_spent + amount,
                                   number_of_borrow: number_of_borrow + 1
                                 })
          # inventory deduction
          @book.update(inventory: @book.inventory - 1)
          deal_hot_book_data
          order
        end
      end

      #
      # Processing data related to popular books
      #
      #
      def deal_hot_book_data
        # get redis values
        redis_book_value = get_redis_value
        redis_book_value[:borrowed_times] += 1
        if redis_book_value[:borrowed_times] >= HOT_LIMIT && !redis_book_value[:is_hot_book] && !redis_book_value[:is_create_hot_book]
          redis_book_value[:is_hot_book] = true
          redis_book_value[:is_create_hot_book] = true
          ::HotBook.create(@book.attributes)
          # Cancel the redis expiration time
          BidMs::Redis.client.persist(book_redis_key)
        end
        # update redis value
        BidMs::Redis.client.set(book_redis_key, redis_book_value.to_json)
      end

      #
      # query book
      #
      #
      def find_book
        super
        set_book_redis_value if get_redis_value.blank?
      end

      #
      # Query book stock
      #
      # @return [String] Return a prompt string or empty
      #
      def check_book_inventory
        redis_book_value = get_redis_value
        if redis_book_value.present? && redis_book_value[:is_hot_book] && redis_book_value[:inventory] < 1
          raise BorrowBookCommandError, 'Insufficient stock'
        end
        return if @book.is_a?(HotBook)

        find_book
        raise BorrowBookCommandError, 'Insufficient stock' if @book.inventory < 1
      end

    end
  end
end
