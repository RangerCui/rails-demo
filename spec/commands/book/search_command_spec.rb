require 'rails_helper'

RSpec.describe V1::Book::SearchCommand do

  before do
    @book = create(:book)
    @user = create(:user)
    @account = create(:account, user: @user)
    @daily_profit = create(:daily_profit, book: @book)
    @daily_profit_last_two_day = create(:daily_profit, :last_two_day, book: @book)
    @order = create(:order, book: @book, account: @account)
    @order_last_three_day = create(:order, :last_three_day, book: @book, account: @account)
  end

  describe 'raise error' do

    it 'Book does not exist' do
      params = { book_id: 101 }
      expect { ::V1::Borrow::BorrowBookCommand.run(params).perform }.to raise_error(ApplicationCommandError, 'Book does not exist')
    end
  end

  describe 'compute book amount' do
    it 'start time and end time blank' do
      params = { book_id: 1 }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(200.0)
    end

    it 'start time present, end time blank' do
      params = { book_id: 1, start_time: '2023-07-06 20:59:52 +0800' }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(201.0)
    end

    it 'start time blank, end time present' do
      params = { book_id: 1, end_time: '2023-07-09 23:59:52 +0800'.to_s }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(101.0)
    end

    it 'start time end time are present' do
      params = { book_id: 1, start_time: '2023-07-06 20:59:52 +0800', end_time: '2023-07-09 23:59:52 +0800' }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(102.0)
    end

    it 'Adjacent days' do
      params = { book_id: 1, start_time: '2023-07-08 23:59:52 +0800', end_time: '2023-07-09 23:59:52 +0800' }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(1.0)
    end

    it 'Same date' do
      params = { book_id: 1, start_time: '2023-07-09 00:00:00 +0800', end_time: '2023-07-09 23:59:52 +0800' }
      cmd = ::V1::Book::SearchCommand.run(params)
      expect(cmd.success?).to be true
      amount = cmd.result
      expect(amount).to eq(1.0)
    end

  end
end
