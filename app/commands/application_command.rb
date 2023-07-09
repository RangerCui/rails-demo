# frozen_string_literal: true

class ApplicationCommandError < StandardError; end

#
# general Command
#
# @author hubery
#
class ApplicationCommand < ActForm::Command

  DAILY_CONSUMPTION = 1

  #
  # base data check
  #
  # @return [Object] return the account objects
  #
  def data_check
    if user_id.present?
      @user = ::User.find_by_id user_id
      raise ApplicationCommandError, 'User does not exist' if @user.blank?

      @account = @user.account
      raise ApplicationCommandError, 'Account does not exist' if @account.blank?
    end

    find_book if book_id.present?
  end

  #
  # query book
  #
  #
  def find_book
    redis_book_value = get_redis_value
    redis_value_blank = redis_book_value.blank?
    target_class = if redis_value_blank || !redis_book_value[:is_hot_book]
                     ::Book
                   else
                     ::HotBook
                   end
    @book = target_class.find_by_id book_id
    raise ApplicationCommandError, 'Book does not exist' if @book.blank?

  end

  #
  # Get redis data
  #
  # @return [Hash] return redis data
  #
  def get_redis_value
    begin
      JSON.parse(BidMs::Redis.client.get(book_redis_key)).deep_symbolize_keys
    rescue
      {}
    end
  end

  #
  # Generate a redis key
  #
  # @return [String] return redis key
  #
  def book_redis_key
    "borrow_book_#{book_id}"
  end

  #
  # Set redis data
  #
  #
  def set_book_redis_value
    BidMs::Redis.client.set(
      book_redis_key,
      { inventory: @book.inventory,
        is_hot_book: false,
        borrowed_times: 0,
        is_create_hot_book: false
      }.to_json
    )
    BidMs::Redis.client.expireat(book_redis_key, (Time.now.beginning_of_day + 1.day).to_i)
  end

  #
  # Calculate the cost of borrowing books over a period of time
  #
  # @param [String] borrowed_time  Book borrow to time
  # @param [String] return_time    Books return to time
  #
  # @return [Float]                Amount generated
  #
  def compute_amount(borrowed_time = nil, return_time = nil)
    return DAILY_CONSUMPTION if borrowed_time.blank? || return_time.blank?

    borrow_dies = (return_time - borrowed_time).to_i
    borrow_dies.zero? ? DAILY_CONSUMPTION : DAILY_CONSUMPTION * borrow_dies
  end

end
