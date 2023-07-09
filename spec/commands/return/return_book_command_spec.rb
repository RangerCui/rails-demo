require 'rails_helper'

RSpec.describe ::V1::Return::ReturnBookCommand do
  before do
    @order = create(:order, :last_three_day)
    @account = @order.account
  end


  describe 'raise error' do
    it 'User does not exist' do
      params = { book_id: 1, user_id: 11 }
      expect { ::V1::Return::ReturnBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'User does not exist')
    end
    it 'Account does not exist' do
      params = { book_id: 1, user_id: 1 }
      @order.account.delete
      expect { ::V1::Return::ReturnBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'Account does not exist')
    end

    it 'Order does not exist' do
      params = { book_id: 1, user_id: 1, order_id: 10 }
      expect { ::V1::Return::ReturnBookCommand.run(params).perform }.to raise_error(::V1::Return::ReturnBookCommandError, 'The book loan order does not exist')
    end

    it 'Without the order id, the order does not exist' do
      params = { book_id: 1, user_id: 1 }
      @order.update(account_id: 12)
      expect { ::V1::Return::ReturnBookCommand.run(params).perform }.to raise_error(::V1::Return::ReturnBookCommandError, 'The book loan order does not exist')
    end
  end

  describe 'cache check' do
    before do
      BidMs::Redis.client.del('book_borrow_1')
    end
    it 'check cached had updated' do
      params = { book_id: 1, user_id: 1 }
      raw_data = get_redis_value(params[:book_id])
      cmd = ::V1::Return::ReturnBookCommand.run(params)
      expect(cmd.success?).to be true
      new_redis_value = get_redis_value(params[:book_id])
      expect(new_redis_value[:inventory]).to eq(raw_data[:inventory] + 1)
    end
  end

  describe 'check order and related data had updated' do
    before do
      @raw_balance = @account.balance
    end

    it 'check order' do
      params = { book_id: 1, user_id: 1 }
      cmd = ::V1::Return::ReturnBookCommand.run(params)
      expect(cmd.success?).to be true
      order = cmd.result
      amount = (Date.parse(Time.now.to_s) - Date.parse(order.borrowed_at.to_s)).to_i
      expect(order.status).to eq('returned')
      expect(order.amount).to eq(amount)
    end

    it 'check account balance' do
      params = { book_id: 1, user_id: 1 }
      cmd = ::V1::Return::ReturnBookCommand.run(params)
      expect(cmd.success?).to be true
      order = cmd.result
      amount = (Date.parse(Time.now.to_s) - Date.parse(order.borrowed_at.to_s)).to_i
      account = cmd.result.account.reload
      expect(account.balance).to eq(@account.balance - amount)
    end

    it 'When the account balance is insufficient to pay, the balance is 0' do
      params = { book_id: 1, user_id: 1 }
      @order.account.update(balance: 2.0)
      cmd = ::V1::Return::ReturnBookCommand.run(params)
      expect(cmd.success?).to be true
      account = cmd.result.account.reload
      expect(account.balance).to eq(0.0)
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
