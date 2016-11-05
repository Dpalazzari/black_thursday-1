require_relative 'test_helper'
require_relative '../lib/sales_analyst'
require_relative '../lib/sales_engine'


class SalesAnalystTest < Minitest::Test
  attr_reader :se,
              :sa

  def setup
    @se = SalesEngine.from_csv({
      :items         => 'data/items.csv',
      :merchants     => 'data/merchants.csv',
      :invoices      => 'data/invoices.csv',
      :invoice_items => 'data/invoice_items.csv',
      :transactions  => 'data/transactions.csv',
      :customers     => 'data/customers.csv'})
  @sa = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert @sa
  end

  def test_load_items_returns_hash
    assert_equal Hash, sa.items.class
  end

  def test_merchants_is_array_class
    assert_equal Array, sa.merchants.class
  end

  def test_new_sales_analyst_initializes_as_sales_engine
    result= sa.sales_engine.class
    assert_equal SalesEngine, result
  end

  def test_average_gives_average
    array = [3,4,5]
    result = sa.average(array)
    assert_equal 4, result
  end
  #
  # def test_average_items_per_merchant
  #   result = sa.average_items_per_merchant
  #   assert_equal 0.07, result
  # end

  def test_standard_deviation_gives_standard_dev
    array = [3,4,5]
    result = sa.find_standard_deviation(array)
    assert_equal 1, result
  end

  def test_average_items_per_merchant
    result = sa.average_items_per_merchant
    assert_equal 2.88, result
    assert_equal Float, result.class
  end

  def test_average_items_per_merchant_std_dev
    result = sa.average_items_per_merchant_standard_deviation
    assert_equal 3.26, result
    assert_equal Float, result.class
  end

  def test_it_finds_merchants_with_high_item_counts
    result = sa.merchants_with_high_item_count
    assert_equal "Keckenbauer", result.first.name
  end

  def test_average_item_price_for_merchant_returns_price
    result = sa.average_item_price_for_merchant(12334105)
    assert_equal BigDecimal, result.class
    assert_equal 16.66 , result.to_f
  end

  def test_average_average_price_per_merchant
    result = sa.average_average_price_per_merchant
    assert_equal BigDecimal, result.class
    assert_equal 350.29, result.to_f
  end

  def test_item_standard_deviation
    result = sa.get_item_standard_deviation
    assert_equal Float, result.class
    assert_equal 2900.99, result.round(2)
  end

  def test_golden_items_returns_array
    result = sa.golden_items
    assert_equal Array, result.class
  end

  def test_golden_items_threshold
    result = sa.golden_items_compared_to_threshold(100)
    assert_equal Item, result.first.class
    assert_equal "Course contre la montre", result.first.name
  end

  def test_it_finds_average_invoices_per_merchant
    result = sa.average_invoices_per_merchant
    assert_equal 10.49, result
    assert_equal Float, result.class
  end

  def test_average_invoices_standard_deviation
    r = sa.average_invoices_per_merchant_standard_deviation
    assert_equal 3.29, r
  end

  def test_it_can_find_the_top_merchants_by_invoice_count
    result = sa.top_merchants_by_invoice_count
    assert_equal Array, result.class
    assert_equal 12, result.count
  end

  def test_it_can_find_the_bottom_merchants_by_invoice_count
    result = sa.top_merchants_by_invoice_count
    assert_equal 12, result.count
  end

  def test_it_can_tell_us_the_day_of_the_week_from_date
    result = sa.top_days_by_invoice_count
    assert_equal ["Wednesday"], result
  end

  def test_invoice_status_matches_status
    result = sa.invoice_status(:pending)
    assert_equal Float, result.class
    assert_equal 29.55, result
  end

end
