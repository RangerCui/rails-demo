require './spec/example/bank_account'

RSpec.describe BankAccount do
  before :each do
    @account = BankAccount.new(10)
  end

  describe 'Deposit function' do
    it 'The original account had 10 yuan, after depositing -5 yuan, the account balance is still 10 yuan (can not deposit less than or equal to zero amount)' do
      @account.deposit -5
      expect(@account.balance).to be 10
    end

    it 'The original account had 10 yuan, after the deposit of 5 yuan, the account balance changed to 15 yuan' do
      @account.deposit 5
      expect(@account.balance).to be 15
    end
  end

  describe 'Withdrawal function' do
    it 'The original account had 10 yuan, after withdrawing 10 yuan, the account remains 0 yuan (can not withdraw the amount less than or equal to 0)' do
      @account.withdraw 10
      expect(@account.balance).to be 0
    end

    it 'The original account has 10 yuan, withdraw 30 yuan, the account remains 10 yuan, can not withdraw more than the balance amount' do
      @account.withdraw 30
      expect(@account.balance).to be 10
    end

  end
end
