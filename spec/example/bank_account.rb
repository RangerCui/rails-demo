class BankAccount

  def initialize(amount)
    @amount = amount
  end

  def deposit(amount)
    @amount += amount if amount > 0
  end

  def withdraw(amount)
    @amount -= amount if amount > 0 && amount <= @amount
  end

  def balance
    @amount
  end

end