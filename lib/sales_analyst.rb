require 'pry'
require 'time'

class SalesAnalyst
  attr_reader :sales_engine,
              :items,
              :merchants,
              :invoices,
              :transactions

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @items        = load_items
    @merchants    = load_merchants
    @invoices     = load_invoices
    @transactions = sales_engine.transactions
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

  def average_items_per_merchant
    items_count      = sales_engine.items.all.count
    merchants_count  = sales_engine.merchants.all.count
    average          = items_count.to_f / merchants_count.to_f
    average.round(2)
  end

  def average_items_per_merchant_standard_deviation
    items_per_merchant = @merchants.map do |merchant_instance|
      merchant_instance.items.count
    end
    find_standard_deviation(items_per_merchant).round(2)
  end

  def merchants_with_high_item_count
    std_dev   = average_items_per_merchant_standard_deviation
    threshold = std_dev + average_items_per_merchant
    @merchants.find_all {|merchant| merchant.items.count > threshold}
  end

  def average_item_price_for_merchant(id)
    prices = @items[id].map { |item| item.unit_price.to_f }
    BigDecimal.new(average(prices).to_f, 5).round(2)
  end

  def average_average_price_per_merchant
    average_price = average(get_prices)
    BigDecimal.new(average_price, 6).floor(2)
  end

  def get_prices
    @items.keys.map do |id|
      average_item_price_for_merchant(id)
    end
  end

  def get_item_average_price
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    average(item_prices)
  end

  def get_item_standard_deviation
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    find_standard_deviation(item_prices)
  end

  def golden_items
    mean         = get_item_average_price
    std_dev      = get_item_standard_deviation
    threshold    = BigDecimal(mean + (std_dev * 2), 4)
    golden_items_compared_to_threshold(threshold)
  end

  def golden_items_compared_to_threshold(threshold)
    @sales_engine.items.all.find_all do |item|
        item.unit_price > threshold
      end
  end

  def average_invoices_per_merchant
    merchant_count = @merchants.count
    invoice_count  = @sales_engine.invoices.all.count
    (invoice_count.to_f/merchant_count.to_f).round(2)
  end

  def average_invoices_per_merchant_standard_deviation
    invoices_per_merchant = @merchants.map do |merchant_instance|
      merchant_instance.invoices.count
    end
    find_standard_deviation(invoices_per_merchant).round(2)
  end

  def top_merchants_by_invoice_count
    std_dev   = average_invoices_per_merchant_standard_deviation
    threshold = (std_dev * 2) + average_invoices_per_merchant
    @merchants.find_all {|merchant| merchant.invoices.count > threshold}
  end

  def bottom_merchants_by_invoice_count
    std_dev   = average_invoices_per_merchant_standard_deviation
    threshold = average_invoices_per_merchant - (std_dev * 2)
    bottom_invoice_count(threshold)
  end

  def bottom_invoice_count(threshold)
    @merchants.find_all do |merchant|
        merchant.invoices.count < threshold
      end
  end

  def top_days_by_invoice_count
    invoices_by_day.keys.select do |day|
      invoices_by_day[day].count > find_threshold(invoice_count_by_day)
    end
  end

  def find_threshold(array)
    std_dev   = find_standard_deviation(array)
    avg       = average(array)
    threshold = (std_dev) + avg
  end

  def invoice_count_by_day
    invoices_by_day.keys.map do |key|
      invoices_by_day[key].count
    end
  end

  def invoices_by_day
    sales_engine.invoices.all.group_by do |invoice_instance|
      Time.at(invoice_instance.created_at).strftime("%A")
    end
  end

  def invoice_status(status)
    matches = sales_engine.invoices.all.find_all do |invoice_instance|
      invoice_instance.status == status
    end
    ((matches.count/sales_engine.invoices.all.count.to_f)*100).round(2)
  end

  def total_revenue_by_date(date)
    invoice_days = sales_engine.invoices.find_all_by_date(date)
    invoice_days.map do |invoice|
      invoice.total
    end.compact.reduce(:+)
  end

  def top_revenue_earners(x=20)
    merchants_ranked_by_revenue[0..(x-1)]
  end

  def merchants_ranked_by_revenue
    merchants = find_revenue.sort_by(&:last).reverse
    merchants.map do |merchant|
      sales_engine.merchants.find_by_id(merchant[0])
    end
  end

  def find_revenue
    invoices.map do |merchant_id, values|
      [merchant_id, values.inject(0) do |sum, invoice_instance|
        sum += invoice_instance.total.to_f
      end]
    end
  end

  def merchants_with_pending_invoices
    find_status.map do |invoice|
      sales_engine.merchants.find_by_id(invoice.merchant_id)
    end.uniq
  end

  def find_status
    sales_engine.invoices.all.find_all do |invoice|
      !invoice.is_paid_in_full?
    end
  end

  def merchants_with_only_one_item
    @merchants.find_all {|merchant| merchant.items.count == 1}
  end

  def merchants_with_only_one_item_registered_in_month(months_name)
    merchants_created_in_month = sales_engine.merchants.find_all_by_month_created(months_name)
    merchants_created_in_month.find_all do |merchant|
      merchant.items.length == 1
    end
  end

  def revenue_by_merchant(merchant_id)
    if invoices[merchant_id]
      invoices[merchant_id].map do |invoice|
        invoice.total
      end.compact.reduce(:+)
    end
  end

  def most_sold_item_for_merchant(merchant_id)
  #  quantities = Hash.new{0}
   find_purchased_items_by_merchant_id(merchant_id).values.map do |item|
      item.reduce(0) do |total, invoice_item|
        total += invoice_item.quantity
      end
    end
    binding.pry
    find_items_by_item_ids(find_top_items(quantities))
  end

  def find_purchased_items_by_merchant_id(merchant_id)
    paid_invoice_items = invoices[merchant_id].map do |invoice|
      invoice.invoice_items if invoice.is_paid_in_full?
    end.compact.flatten
    paid_invoice_items.group_by { |item| item.item_id }
  end

  def find_top_items(quantities)
    quantities.select do |key,value|
      key if value == quantities.values.max
    end
  end

  def find_items_by_item_ids(array)
    array.map do |id|
      sales_engine.items.find_by_id(id)
    end.flatten
  end

  # def best_item_for_merchant(merchant_id)
  #   our_merchant = sales_engine.merchants.all.find do |merchant|
  #     merchant.id == merchant_id
  #   end
  #   paid_invoice_items = our_merchant.invoices.find_all do |invoice|
  #     invoice.is_paid_in_full?
  #   end
  #   paid_invoice_items = paid_invoice_items.flat_map do |invoice|
  #     invoice.invoice_items
  #   end
  #   items = paid_invoice_items.group_by do |item|
  #     item.item_id
  #   end
  #   reduced = Hash.new{0}
  #   items.each do |key, value|
  #     reduced[key] = value.reduce(0){ |total, sumtin| total += sumtin.quantity * sumtin.unit_price }
  #   end
  #   max = reduced.values.max
  #   almost_done = reduced.select do |key,value|
  #     key if value == max
  #   end
  #   sales_engine.items.all.find do |item|
  #     almost_done.keys.first == item.id
  #   end
  # end
end
