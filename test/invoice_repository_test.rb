require_relative '../test/test_helper'
require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'

class InvoiceRepositoryTest < Minitest::Test

  attr_reader :invoices
  def setup
    se = SalesEngine.from_csv({
              :items     => 'data/item_fixture.csv',
              :merchants => 'data/merchants_fixture.csv',
              :invoices  => 'data/invoices_fixtures.csv'})
    @invoices = se.invoices
  end

  def test_it_exists
    assert @invoices
  end

  def test_find_by_id_returns_nil_when_no_invoice
    result = @invoices.find_by_id(1000)
    assert_equal nil, result
  end

  def test_find_by_id_returns_correct_invoice
    result = @invoices.find_by_id(1)
    assert_equal Invoice, result.class
    assert_equal 1, result.id
  end

  def test_find_all_by_customer_id_returns_empty_hash_if_empty
    result = @invoices.find_all_by_customer_id(1000)
    assert_equal [], result
  end

  def test_find_all_by_customer_id
    result = @invoices.find_all_by_customer_id(10)
    assert_equal Array, result.class
    assert_equal 10, result[0].customer_id
    assert_equal 2, result.length
  end

  def test_it_has_merchant_id_returns_empty_hash_if_empty
    result = @invoices.find_all_by_merchant_id(1000)
    assert_equal [], result
  end

  def test_find_all_by_merchant_id
    result = @invoices.find_all_by_merchant_id(12335938)
    assert_equal Array, result.class
    assert_equal 12335938, result[0].merchant_id
    assert_equal 2, result.length
  end

  def test_find_all_by_status_gives_empty_array_if_empty
    result = @invoices.find_all_by_status(:shazzam)
    assert_equal Array, result.class
    assert_equal [], result
  end

  def test_find_all_by_status_gives_correct_invoices
    result = @invoices.find_all_by_status(:pending)
    assert_equal Array, result.class
    assert_equal 2, result.count
  end

  def test_invoice_can_ask_for_merchant
    parent = Minitest::Mock.new
    invoices = InvoiceRepository.new('data/invoices_fixtures.csv', parent)
    parent.expect(:find_merchant_by_id, nil, [12335938])
    invoices.find_merchant(12335938)
    assert parent.verify
  end
end
