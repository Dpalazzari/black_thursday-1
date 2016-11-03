require 'pry'

class SalesAnalyst
  attr_reader :sales_engine,
              :items,
              :merchants,
              :invoices

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items = load_items
    @merchants = load_merchants
    @invoices = load_invoices
  end

  def load_items
    sales_engine.load_items
  end

  def load_merchants
    sales_engine.merchants.all
  end

  def load_invoices
    sales_engine.load_invoices
  end

  def average(array)
    array.inject{ |sum, element| sum + element }.to_f / array.count
  end

  def find_standard_deviation(array)
    mean        = average(array)
    sum_squares = array.inject(0) { |sum, element| sum + (mean - element)**2 }
    Math.sqrt(sum_squares / (array.length - 1))
  end

  ### --- merchant methods --- ###

  def average_items_per_merchant
    items_count      = sales_engine.items.all.count
    merchants_count  = sales_engine.merchants.all.count
    average          = items_count.to_f / merchants_count.to_f
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant = []
    @merchants.each do |merchant_instance|
      items_per_merchant << merchant_instance.items.count
    end
    result = find_standard_deviation(items_per_merchant)
    return result.round(2)
  end

  def merchants_with_high_item_count
    std_dev = average_items_per_merchant_standard_deviation
    threshold = std_dev + average_items_per_merchant
    @merchants.find_all do |merchant|
        merchant.items.count > threshold
      end
  end

  def average_item_price_for_merchant(id)
    prices = @items[id].map { |item| item.unit_price.to_f }
    return BigDecimal.new(average(prices).to_f, 5).round(2)
  end

  def average_average_price_per_merchant
    # need to find another way to get array of merchant ids
    prices = @items.keys.map do |id|
      average_item_price_for_merchant(id)
    end
    average_price = average(prices)
    return BigDecimal.new(average_price, 6).floor(2)
  end

  ### --- item methods --- ###

  def get_item_average_price
    item_prices = []
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    average(item_prices)
  end

  def get_item_standard_deviation
    item_prices = []
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    find_standard_deviation(item_prices)
  end

  def golden_items
    ave = get_item_average_price
    std_dev = get_item_standard_deviation
    threshold = BigDecimal(ave + std_dev, 4)
    golden_items = @sales_engine.items.all.find_all do |item|
        item.unit_price > threshold * 2
      end
      golden_items
  end

  ### --- invoice methods --- ###

  def average_invoices_per_merchant
    merchant_count = @merchants.all.count
    invoice_count  = @invoices.all.count
    invoice_count/merchant_count
  end

  def average_invoices_per_merchant_standard_deviation
    # result should look like => 1.2
  end

  def top_merchants_by_invoice_count
    # Which merchants are more than 2 standard devs above mean?
    # result should look like [merchant, merchant, merchant]
  end

  def bottom_merchants_by_invoice_count
    # Which merchants are more than 2 standard devs below mean?
    # result should look like [merchant, merchant, merchant]
  end

  def top_days_by_invoice_count
    # result should look like ["Sunday", "Saturday"]
  end

  def invoice_status(status)
    # returns percentage of invoices with status (as a symbol)
    # result should look like 5.25
  end
end
