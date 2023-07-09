# frozen_string_literal: true

module V1
  module Return

    class ReturnBookCommandError < StandardError; end

    #
    # Book return command. All the business logic of book return is carried out in this command
    # @author hubery.cui
    #
    class ReturnBookCommand < ApplicationCommand
      attribute :user_id, required: true
      attribute :book_id, required: true
      attribute :order_id, required: false

      MINIMUM_CHARGE = 1

      #
      # main method
      #
      #
      # @return [Object] user
      #
      def perform
        data_check
        order = if order_id.present?
                  Order.find_by(id: order_id)
                else
                  Order.find_by(account_id: @account.id, status: :borrowed, book_id: book_id)
                end
        raise ReturnBookCommandError, 'The book loan order does not exist' if order.blank?

        current_time = Time.now
        amount = compute_amount(Date.parse(order.borrowed_at.to_s), Date.parse(current_time.to_s))

        amount ||= MINIMUM_CHARGE

        order.update!(
          {
            status: ::Order.statuses['returned'],
            actual_return_time: current_time,
            amount: amount
          }
        )
        @book.update(inventory: @book.inventory + 1)

        book_redis_value = get_redis_value
        # update cache
        if book_redis_value.present?
          book_redis_value[:inventory] += 1
          BidMs::Redis.client.set(book_redis_key, book_redis_value.to_json)
        end

        account_balance = @account.balance - amount
        @account.balance = account_balance.positive? ? account_balance : Account::MINIMUM_BALANCE
        @account.save

        order
      end

    end
  end
end
