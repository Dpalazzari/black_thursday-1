require_relative '../test/test_helper'
require_relative '../lib/sales_engine'


class SalesEngineTest < Minitest::Test
  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
              :items         => 'fixture/item_fixture_2.csv',
              :merchants     => 'data/merchants_fixture.csv',
              :invoices      => 'data/invoices_fixtures.csv',
              :invoice_items => 'fixture/invoice_item_fixture.csv',
              # :transactions  => 'fixture/transaction_fixture.csv',
              :customers     => 'data/customers.csv'})
  end

  def test_from_csv_instatiates_sales_engine_with_repositories
    assert_equal SalesEngine, se.class
    assert_equal ItemRepository, se.items.class
    assert_equal MerchantRepository, se.merchants.class
    assert_equal InvoiceRepository, se.invoices.class
    assert_equal InvoiceItemRepository, se.invoice_items.class
    # assert_equal TransactionRepository, se.transactions.class
    assert_equal CustomerRepository, se.customers.class
  end

  def test_loads_items_from_csv
    result = se.items.all.first
    assert_equal Item, result.class
    assert_equal "Custom Hand Made Miniature Bicycle", result.name
    assert_equal 263400121, result.id
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
    skip
    result = se.transactions.all.first
    assert_equal Transaction, result.class
    assert_equal 0, result.items.count
  end

  def test_loads_customers_from_csv
    result = se.customers.all.first
    assert_equal Customer, result.class
    assert_equal 1, result.id
  end

  def test_it_creates_a_hash_of_item_instances
    result = se.load_items
    assert_equal Hash, result.class
    assert_equal 12334113, result.keys.first
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

  # def teset_find_merchant_by_id
  #   skip
  # end
  #
  # def test_find_all_invoices_by_merchant_id
  #   skip
  # end

end
