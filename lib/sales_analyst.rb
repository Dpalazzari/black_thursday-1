require 'time'
require_relative 'calculator'

class SalesAnalyst
  include Calculator

  attr_reader :sales_engine,
              :items,
              :merchants,
              :invoices,
              :transactions

  def initialize(sales_engine)
    @sales_engine ||= sales_engine
    @items        ||= load_items
    @merchants    ||= load_merchants
    @invoices     ||= load_invoices
    @transactions ||= sales_engine.transactions
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
    (std_dev) + avg
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
    merchants_created_in_month = sales_engine.
                                 merchants.
                                 find_all_by_month_created(months_name)
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
    invoiced_items = find_invoiced_items_for_merchant(merchant_id)
    quantities = find_item_quantity(invoiced_items)
    best_item_ids = find_most_sold_items(quantities)
    find_items_by_ids(best_item_ids)
  end

  def find_most_sold_items(array)
    max_quantity = array.sort_by(&:last)[-1][1]
    array.map do |sub_array|
      sub_array[0] if sub_array[1] == max_quantity
    end.compact
  end

  def best_item_for_merchant(merchant_id)
    invoiced_items = find_invoiced_items_for_merchant(merchant_id)
    revenues = find_item_revenue(invoiced_items)
    best_item_id = revenues.sort_by(&:last)[-1][0]
    find_item_by_id(best_item_id)
  end

  def find_invoiced_items_for_merchant(merchant_id)
    invoices[merchant_id].map do |invoice|
      invoice.invoice_items if invoice.is_paid_in_full?
    end.flatten
  end

  def find_item_revenue(invoice_items)
    invoice_items.compact.map do |invoice_item|
      result = invoice_item.quantity * invoice_item.unit_price
      [invoice_item.item_id, result]
    end
  end

  def find_item_quantity(invoice_items)
    invoice_items.compact.map do |invoice_item|
      result = invoice_item.quantity
      [invoice_item.item_id, result]
    end
  end

  def find_item_by_id(id)
    sales_engine.items.find_by_id(id)
  end

  def find_items_by_ids(array)
    array.map { |id| sales_engine.items.find_by_id(id) }
  end
end
