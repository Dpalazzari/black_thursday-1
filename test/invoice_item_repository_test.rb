require_relative '../test/test_helper'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/sales_engine'

class InvoiceItemRepositoryTest < Minitest::Test
  attr_reader :se,
              :invoice_items

  def setup
    se = SalesEngine.from_csv({
      :items         => 'data_min/items.csv',
      :merchants     => 'data_min/merchants.csv',
      :invoices      => 'data_min/invoices.csv',
      :invoice_items => 'data_min/invoice_items.csv',
      :transactions  => 'data_min/transactions.csv',
      :customers     => 'data_min/customers.csv'})
    @invoice_items = se.invoice_items
  end

  def test_it_exists
    assert invoice_items
  end

  def test_find_by_id_returns_nil_when_no_invoice
    result = invoice_items.find_by_id(3000)
    assert_equal nil, result
  end

  def test_find_by_id_returns_correct_invoice
    result = invoice_items.find_by_id(1)
    assert_equal InvoiceItem, result.class
    assert_equal 1, result.id
  end

  def test_find_all_by_item_id_returns_invoice_item
    result = invoice_items.find_all_by_item_id(6)
    assert_equal Array, result.class
    assert_equal InvoiceItem, result[0].class
    assert_equal 6, result.first.item_id
  end

  def test_find_all_by_invoice_id_returns_invoice_item
    result = invoice_items.find_all_by_invoice_id(2)
    assert_equal Array, result.class
    assert_equal InvoiceItem, result[0].class
    assert_equal 21, result.first.item_id
  end

  def test_invoice_items_can_ask_for_items
    parent = Minitest::Mock.new
    invoice_items = InvoiceItemRepository.new('data_min/invoice_items.csv', parent)
    parent.expect(:find_items_by_item_id, nil, [2])
    invoice_items.find_items(2)
    assert parent.verify
  end
end
