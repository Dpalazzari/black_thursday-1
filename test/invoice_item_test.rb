require_relative '../test/test_helper'
require_relative '../lib/invoice_item'

class InvoiceItemTest < Minitest::Test
  attr_reader :invoice_item

  def setup
    @invoice_item = InvoiceItem.new({
      :id         => "6",
      :item_id    => "7",
      :invoice_id => "8",
      :quantity   => "1",
      :unit_price => "13635",
      :created_at => "2012-03-27 14:54:09 UTC",
      :updated_at => "2012-03-27 14:54:09 UTC"
      })
  end

  def test_initializes_with_given_hash
    assert_equal Fixnum, invoice_item.id.class
    assert_equal 6, invoice_item.id
    assert_equal Fixnum, invoice_item.item_id.class
    assert_equal 7, invoice_item.item_id
    assert_equal Fixnum, invoice_item.invoice_id.class
    assert_equal 8, invoice_item.invoice_id
    assert_equal Fixnum, invoice_item.quantity.class
    assert_equal 1, invoice_item.quantity
  end

  def test_find_unit_price
    result = invoice_item.unit_price
    assert_equal BigDecimal, result.class
    assert_equal 136.35, result.to_f
  end

  def test_unit_price_to_dollars_gives_dollars
    result = invoice_item.unit_price_to_dollars(invoice_item.unit_price)
    assert_equal Float, result.class
    assert_equal 136.35, result
  end

  def test_determine_the_time_returns_time
    result = invoice_item.created_at
    result2 = invoice_item.updated_at
    assert_equal Time, result.class
    assert_equal Time, result2.class
  end

  def test_invoiceitem_can_ask_for_item
    parent = Minitest::Mock.new
    invoice_item = InvoiceItem.new({
      :id         => "6",
      :item_id    => "7",
      :invoice_id => "8",
      :quantity   => "1",
      :unit_price => "13635",
      :created_at => "2012-03-27 14:54:09 UTC",
      :updated_at => "2012-03-27 14:54:09 UTC"
      }, parent)
    parent.expect(:find_items, nil, [invoice_item.item_id])
    invoice_item.item
    assert parent.verify
  end
end
