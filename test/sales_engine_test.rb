require_relative '../test/test_helper'
require_relative '../lib/sales_engine'


class SalesEngineTest < Minitest::Test
  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
              :items         => 'fixture/items_fixture_3.csv',
              :merchants     => 'fixture/merchants_fixture.csv',
              :invoices      => 'fixture/invoices_fixtures.csv',
              :invoice_items => 'fixture/invoice_item_fixture.csv',
              :transactions  => 'fixture/transaction_fixture.csv',
              :customers     => 'data/customers.csv'})
  end

  def test_from_csv_instatiates_sales_engine_with_repositories
    assert_equal SalesEngine, se.class
    assert_equal ItemRepository, se.items.class
    assert_equal MerchantRepository, se.merchants.class
    assert_equal InvoiceRepository, se.invoices.class
    assert_equal InvoiceItemRepository, se.invoice_items.class
    assert_equal TransactionRepository, se.transactions.class
    assert_equal CustomerRepository, se.customers.class
  end

  def test_loads_items_from_csv
    result = se.items.all.first
    assert_equal Item, result.class
    assert_equal "Glitter scrabble frames", result.name
    assert_equal 263395617, result.id
  end

  def test_loads_merchants_from_csv
    result = se.merchants.all.first
    assert_equal Merchant, result.class
    assert_equal 12334105, result.id
    assert_equal "Shopin1901", result.name
  end

  def test_loads_invoices_from_csv
    result = se.invoices.all.first
    assert_equal Invoice, result.class
    assert_equal 1, result.id
    assert_equal 12335938, result.merchant_id
  end

  def test_loads_invoice_items_from_csv
    result = se.invoice_items.all.first
    assert_equal InvoiceItem, result.class
    assert_equal 1, result.id
    assert_equal 263519844, result.item_id
  end

  def test_loads_transactions_from_csv
    result = se.transactions.all.first
    assert_equal Transaction, result.class
    assert_equal 2179, result.invoice_id
  end

  def test_loads_customers_from_csv
    result = se.customers.all.first
    assert_equal Customer, result.class
    assert_equal 1, result.id
  end

  def test_it_creates_a_hash_of_item_instances
    result = se.load_items
    assert_equal Hash, result.class
    assert_equal 12334105, result.keys.first
  end

  def test_it_loads_invoices
    result = se.load_invoices
    assert_equal Hash, result.class
    assert_equal 12335938, result.keys.first
  end

  def test_find_all_items_by_merchant_id
    result = se.find_all_items_by_merchant_id(12334185)
    assert_equal Item, result[0].class
  end

  def test_find_merchant_by_id
    result = se.find_merchant_by_id(12334113)
    assert_equal Merchant, result.class
  end

  def test_find_all_invoices_by_merchant_id
    result = se.find_all_invoices_by_merchant_id(12334839)
    assert_equal Invoice, result[0].class
  end

  def test_find_items_by_invoice_id
    result = se.find_items_by_invoice_id(135)
    assert_equal Item, result.compact[0].class
  end

  def test_find_transactions_by_invoice_id
    result = se.find_transactions_by_invoice_id(135)
    assert_equal Transaction, result[0].class
  end

  def test_find_customer_by_id
    result = se.find_customer_by_id(1)
    assert_equal Customer, result.class
    assert_equal "Joey", result.first_name
  end

  def test_find_invoice_by_transaction_id
    result = se.find_invoice_by_id(1)
    assert_equal Invoice, result.class
    assert_equal :pending, result.status
  end

  def test_find_customers_by_merchant_id
    result = se.find_customers_by_merchant_id(12334839)
    assert_equal Array, result.class
    assert_equal Customer, result[0].class
    assert_equal "Cecelia", result[0].first_name
  end

  def test_find_merchants_by_customer_id
    result = se.find_merchants_by_customer_id(42).compact
    assert_equal Array, result.class
    assert_equal Merchant, result[0].class
    assert_equal 12334146, result[0].id
  end

  def test_invoice_paid_in_full_determines_transaction_status
    result = se.invoices.find_by_id(520)
    assert_equal false, result.is_paid_in_full?
    result_2 = se.invoices.find_by_id(2)
    assert_equal true, result_2.is_paid_in_full?
  end

  def test_invoice_total_returns_invoice_total
    result_2 = se.invoices.find_by_id(2)
    assert_equal 5289.13, result_2.total.to_f
  end

  def test_find_invoice_items_by_invoice_id
    result = se.invoices.find_invoice_items_by_invoice_id(2)
    assert_equal InvoiceItem, result[0].class
  end

end
