require 'rails_helper'

RSpec.describe ::V1::User::Info::SearchCommand do
  before do
    @order = create(:order)
    @account = @order.account
    @user = @account.user
  end

  describe 'query user' do
    it 'check user info' do
      params = { user_id: @user.id }
      cmd = ::V1::User::Info::SearchCommand.run(params)
      expect(cmd.success?).to be true
      user = cmd.result[:user_info]
      account = cmd.result[:account_info]
      orders = cmd.result[:order_info]
      expect(user.name).to eq(@user.name)
      expect(user.id).to eq(@user.id)
      expect(account.balance).to eq(@account.balance)
      expect(account.id).to eq(@account.id)
      orders.each do |order|
        expect(order.account_id).to eq(@account.id)
      end
    end
  end

end
