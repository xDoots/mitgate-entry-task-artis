require 'minitest/autorun'
require_relative '../app/vending_machine'

class VendingMachineTest < Minitest::Test
  class << self
    undef_method :test_order
    define_method :test_order do :alpha end
  end

  def setup
    @machine = ::VendingMachine.new
  end

  # NOTE: Class name must match the file name.
  def test_01_vending_machine_class_exists
    assert defined?(::VendingMachine)
    assert_instance_of Class, ::VendingMachine
  end

  # Ruby's attr_accessor is a convenient method that automatically creates both getter and setter methods for instance variables, reducing the need for boilerplate code. Instead of manually defining methods to read and write an instance variable, you simply declare an attribute using attr_accessor and Ruby handles the rest.
  # NOTE: See also https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#encapsulation
  def test_02_vending_machine_attr_accessors
    assert_respond_to @machine, :products
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#instance-methods
  # NOTE: And see https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#classes-and-objects
  def test_03_vending_machine_instance_variables
    assert_instance_of CoinManager, @machine.coin_manager
    assert_instance_of ProductCatalog, @machine.product_catalog
    assert_instance_of TransactionProcessor, @machine.transaction_processor
    assert_instance_of DisplayManager, @machine.display_manager
  end

  def test_04_required_instance_methods
    required_methods = %i[insert select_product balance display_products cancel_transaction]
    required_methods.each do |method|
      assert_respond_to @machine, method
    end
  end

  def test_05_coin_manager_required_instance_methods
    required_methods = %i[add_coins deduct_amount reset_balance]
    required_methods.each do |method|
      assert_respond_to @machine.coin_manager, method
    end
  end

  def test_06_product_catalog_required_instance_methods
    required_methods = %i[available_products find_product update_stock]
    required_methods.each do |method|
      assert_respond_to @machine.product_catalog, method
    end
  end

  def test_07_transaction_processor_required_instance_methods
    required_methods = %i[process_transaction transaction_history calculate_change]
    required_methods.each do |method|
      assert_respond_to @machine.transaction_processor, method
    end
  end

  def test_08_display_manager_required_instance_methods
    required_methods = %i[format_product_list format_transaction_result]
    required_methods.each do |method|
      assert_respond_to @machine.display_manager, method
    end
  end

  def test_09_coin_manager_balance_accessor
    assert_respond_to @machine.coin_manager, :balance
  end

  # NOTE: And see https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#classes-and-objects
  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#nil-value
  def test_10_coin_manager_initialization
    assert_equal 0.0, @machine.coin_manager.balance
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#instance-methods
  def test_11_insert_zero_amount
    initial_balance = 0.0
    @machine.insert(0.0)
    assert_equal initial_balance, @machine.balance
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#instance-methods
  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#flow-control
  def test_12_insert_negative_amount
    @machine.insert(-1.0)
    # NOTE: Expecting the machine to not allow a negative balance.
    assert_operator @machine.balance, :>=, 0
  end

  # NOTE: See https://docs.ruby-lang.org/en/3.4/Integer.html#method-i-2B
  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#nil-value
  def test_13_insert_positive_amount
    @machine.insert(2.0)
    assert_equal 2.0, @machine.balance
  end

  def test_14_multiple_coin_insertions
    @machine.insert(1.0)
    @machine.insert(2.0)
    @machine.insert(0.5)
    assert_equal 3.5, @machine.balance
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#variables-and-types
  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#string-vs-symbol
  def test_15_product_catalog_initialization
    products = @machine.product_catalog.available_products
    refute_empty products
    assert products.all? do |product|
      product[:code] && product[:name] && product[:price]
    end
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#methods
  # NOTE: See https://docs.ruby-lang.org/en/3.4/syntax/literals_rdoc.html#label-Double-Quoted+String+Literals
  def test_16_select_chips_with_sufficient_funds
    @machine.insert(2.0)
    result = @machine.select_product('A1')
    assert_match(/Dispensed Chips crunchy with change 0.5/, result)
  end

  def test_17_select_soda_with_sufficient_funds
    @machine.insert(2.0)
    result = @machine.select_product('B2')
    assert_match(/Dispensed Soda Pop with change 0.0/, result)
  end

  def test_18_select_candy_with_sufficient_funds
    @machine.insert(2.0)
    result = @machine.select_product('C3')
    assert_match(/Dispensed Candy-Crush with change 0.5/, result)
  end

  def test_19_select_product_returns_correct_change
    @machine.insert(3.0)
    result = @machine.select_product('B2')
    # NOTE: Expected change: 3.0 - 2.0 = 1.0
    assert_match(/1.0/, result)
  end

  def test_20_select_product_insufficient_funds
    @machine.insert(1.0)
    result = @machine.select_product('C3')
    assert_equal 'Insufficient funds', result
  end

  def test_21_select_invalid_product
    @machine.insert(5.0)
    result = @machine.select_product('Z9')
    assert_equal 'Invalid product', result
  end

  def test_22_balance_updates_after_purchase
    @machine.insert(5.0)
    @machine.select_product('A1')
    assert_equal 3.5, @machine.balance
  end

  # NOTE: See https://mitigate-dev.github.io/mitigate-akademija/pages/ruby/introduction.html#loops
  # NOTE: See https://docs.ruby-lang.org/en/3.0/syntax/literals_rdoc.html#label-Strings
  def test_23_display_available_products
    product_list = @machine.display_products
    assert_match(/Available Products:/, product_list)
    assert_match(/A1 - Chips crunchy/, product_list)
    assert_match(/1.5/, product_list)
  end

  def test_24_transaction_history
    @machine.insert(5.0)
    @machine.select_product('A1')
    @machine.select_product('B2')
    history = @machine.transaction_processor.transaction_history
    refute_empty history
    assert_equal 2, history.length
  end

  def test_25_product_availability
    @machine.insert(10.0)
    3.times { @machine.select_product('A1') }
    result = @machine.select_product('A1')
    assert_equal 'Product out of stock', result
  end

  def test_26_cancel_transaction
    @machine.insert(5.0)
    result = @machine.cancel_transaction
    assert_equal 0.0, @machine.balance
    assert_match(/Returned 5.0/, result)
  end

  def test_27_display_manager_requires_transaction_processor
    assert_raises(ArgumentError) { DisplayManager.new }
  end

  def test_28_module_inclusion
    assert_includes DisplayManager.included_modules, TransactionFormattable
    assert_includes TransactionProcessor.included_modules, TransactionFormattable
  end

  def test_29_shared_transaction_formatting
    @machine.insert(2.0)
    result = @machine.select_product('A1')
    assert_includes(result, 'Dispensed Chips crunchy with change 0.5')
    assert_includes(result, 'Transaction details: Chips crunchy - Paid: 2.0 - Change: 0.5')
  end
end
