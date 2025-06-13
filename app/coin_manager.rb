class CoinManager
  attr_reader :balance

  def initialize
    @balance = 0.0
  end

  def add_coins(amount)
    return false if amount < 0

    @balance += amount
    true
  end

  def get_balance
    @balance
  end

  def deduct_amount(amount)
    return false if amount > @balance

    @balance -= amount
    true
  end

  def reset_balance
    20
  end
end
