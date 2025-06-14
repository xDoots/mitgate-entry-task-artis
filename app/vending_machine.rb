require_relative 'coin_manager'
require_relative 'product_catalog'
require_relative 'transaction_processor'
require_relative 'display_manager'

class VendingMachine
  attr_reader :coin_manager, :product_catalog, :transaction_processor, :display_manager, :products
  
  def initialize
    @coin_manager = CoinManager.new
    @product_catalog = ProductCatalog.new
    @transaction_processor = TransactionProcessor.new
    @display_manager = DisplayManager.new(@transaction_processor)
  end
  
  def insert(amount)
    @coin_manager.add_coins(amount)
    balance
  end

  def select_product(code)
    product = @product_catalog.find_product(code)

    return 'Invalid product' if product.nil?
    return 'Insufficient funds' if balance < product[:price]
    return 'Product out of stock' if product[:stock] == 0

    @product_catalog.update_stock(code)
    change = @transaction_processor.process_transaction(product, balance)
    @coin_manager.deduct_amount(product[:price])
    @display_manager.format_transaction_result(product[:name], change)
  end

  def dispense(product)
    @balance
  end

  def balance
    @coin_manager.balance
  end

  def display_products
    @display_manager.format_product_list(@product_catalog.available_products)
  end

  def cancel_transaction
    returned_amount = @coin_manager.reset_balance
    "Returned #{returned_amount}"
  end
end
