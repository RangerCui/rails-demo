require 'rails_helper'

RSpec.describe ::V1::Borrow::BorrowBookCommand do
  before do
    @account = create(:account)
    @book = create(:book, inventory: 10)
    @user = @account.user
    @borrowed_at = Time.now
    @estimated_return_time = @borrowed_at + 7.days
  end

  describe 'raise error' do
    before do
      BidMs::Redis.client.del('book_borrow_1')
    end
    it 'Parameter check' do
      params = {}
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.success?).to be false
    end
    it 'user_id must exist' do
      params = { book_id: 1, user_id: nil }
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.errors.full_messages).to include('User必须存在')
    end
    it 'book_id must exist' do
      params = { book_id: nil, user_id: 1 }
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.errors.full_messages).to include('Book必须存在')
    end
    it 'User does not exist' do
      params = { book_id: 1, user_id: 11 }
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'User does not exist')
    end
    it 'Book does not exist' do
      params = { book_id: 101, user_id: 1 }
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'Book does not exist')
    end
    it 'Account does not exist' do
      params = { book_id: 1, user_id: 1 }
      @user.account.delete
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'Account does not exist')
    end
    it 'Insufficient account balance' do
      @no_balance_account = create(:account, :no_balance)

      params = { book_id: 1, user_id: 2 }
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(V1::Borrow::BorrowBookCommandError, 'Insufficient account balance')
    end
    it 'Insufficient stock' do
      params = { book_id: 1, user_id: 1 }
      @book.update(inventory: 0)
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(V1::Borrow::BorrowBookCommandError, 'Insufficient stock')
    end
    it 'Cache insufficient stock' do
      params = { book_id: 1, user_id: 1 }
      redis_value = { inventory: 0, borrowed_times: 9, is_hot_book: false }
      BidMs::Redis.client.set(book_redis_key(params[:book_id]), redis_value.to_json)
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(V1::Borrow::BorrowBookCommandError, 'Insufficient stock')
    end
  end

  describe 'Cache detection' do

    it 'create hot book and check create order' do
      params = { book_id: 1, user_id: 1 }
      redis_value = { inventory: @book.inventory, borrowed_times: 9, is_hot_book: false }
      BidMs::Redis.client.set(book_redis_key(params[:book_id]), redis_value.to_json)
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.success?).to be true
      order = cmd.result
      expect(order.account_id).to eq(@user.account.id)
      expect(order.book_id).to eq(params[:book_id])
      hot_book = HotBook.find_by_id params[:book_id]
      expect(hot_book.present?).to eq(true)
      expect(hot_book.name).to eq(@book.name)
      BidMs::Redis.client.del(book_redis_key(params[:book_id]))
    end

    it 'updates daily profit data' do
      params = { book_id: 1, user_id: 1 }
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.success?).to be true
      order = cmd.result
      daily_profit = DailyProfit.where(book_id: params[:book_id]).last
      expect(daily_profit.amount).to eq(order.amount)
      expect(daily_profit.year).to eq(Time.now.year)
      expect(daily_profit.month).to eq(Time.now.month)
      expect(daily_profit.day).to eq(Time.now.day)
    end

    it 'updates book inventory' do
      params = { book_id: 1, user_id: 1 }
      expect { ::V1::Borrow::BorrowBookCommand.run(params) }.to change { @book.reload.inventory }.by(-1)
    end

    it 'Test cost calculation' do
      params = { book_id: 1, user_id: 1, estimated_return_time: @estimated_return_time }
      cmd = ::V1::Borrow::BorrowBookCommand.run(params)
      expect(cmd.success?).to be true
      order = cmd.result
      expect(order.amount).to eq(7)
    end

  end

  #
  # Get redis data
  #
  # @param [Integer] book_id  params book id
  #
  # @return [Hash] return redis data
  #
  def get_redis_value(book_id)
    begin
      JSON.parse(BidMs::Redis.client.get(book_redis_key(book_id))).deep_symbolize_keys
    rescue
      {}
    end
  end

  #
  # Generate a redis key
  #
  # @param [Integer] book_id  params book id
  #
  # @return [String] return redis key
  #
  def book_redis_key(book_id)
    "borrow_book_#{book_id}"
  end

end
