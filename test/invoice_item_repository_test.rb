require_relative '../test/test_helper'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/sales_engine'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :se,
              :invoice_items

  def setup
    se = SalesEngine.from_csv({
              :items         => 'fixture/items_fixture_3.csv',
              :merchants     => 'fixture/merchants_fixture.csv',
              :invoices      => 'fixture/invoices_fixtures.csv',
              :invoice_items => 'fixture/invoice_item_fixture.csv',
              :transactions  => 'fixture/transaction_fixture.csv',
              :customers     => 'data/customers.csv'})
    @invoice_items = se.invoice_items
  end

  def test_it_exists
    assert invoice_items
  end

  def test_find_by_id_returns_nil_when_no_invoice
    result = invoice_items.find_by_id(1000)
    assert_equal nil, result
  end

  def test_find_by_id_returns_correct_invoice
    result = invoice_items.find_by_id(1)
    assert_equal InvoiceItem, result.class
    assert_equal 1, result.id
  end

  def test_find_all_by_item_id_returns_invoice_item
    result = invoice_items.find_all_by_item_id(263454779)
    assert_equal Array, result.class
    assert_equal InvoiceItem, result[0].class
    assert_equal 263454779, result.first.item_id
  end

  def test_find_all_by_invoice_id_returns_invoice_item
    result = invoice_items.find_all_by_invoice_id(2)
    assert_equal Array, result.class
    assert_equal InvoiceItem, result[0].class
    assert_equal 263529264, result.first.item_id
  end

  # def test_invoice_can_ask_for_merchant
  #   parent = Minitest::Mock.new
  #   invoices = InvoiceRepository.new('data/invoices_fixtures.csv', parent)
  #   parent.expect(:find_merchant_by_id, nil, [12335938])
  #   invoices.find_merchant(12335938)
  #   assert parent.verify
  # end
end
