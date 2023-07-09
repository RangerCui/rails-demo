require 'rails_helper'

RSpec.describe ::V1::User::Manage::SetUserAmountCommand do
  before do
    @account = create(:account)
    @user = @account.user
  end

  describe 'query user' do
    it 'check user info' do
      params = { user_id: @user.id, balance: 666.0 }
      cmd = ::V1::User::Manage::SetUserAmountCommand.run(params)
      expect(cmd.success?).to be true
      account = cmd.result.account
      expect(account.balance).to eq(params[:balance])
    end
  end

end
