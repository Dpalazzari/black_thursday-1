require_relative '../test/test_helper'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test

  attr_reader :invoice
  def setup
    @invoice = Invoice.new(({:id => "1",
                      :customer_id => "2",
                      :merchant_id => "12335938",
                      :status => "pending",
                      :created_at => "2009-02-07",
                      :updated_at => "2014-03-15"
                      }))
  end

  def test_it_can_return_the_merchants_id
    assert_equal Fixnum, invoice.merchant_id.class
    assert_equal 12335938, invoice.merchant_id
  end

  def test_it_can_return_the_invoice_id
    assert_equal Fixnum, invoice.id.class
    assert_equal 1, invoice.id
  end

  def test_it_can_return_the_customer_id
    assert_equal Fixnum, invoice.customer_id.class
    assert_equal 2, invoice.customer_id
  end

  def test_it_can_return_the_status_of_the_shipment
    assert_equal :pending, invoice.status
  end

  def test_it_outputs_the_time_int_the_correct_format
    assert_equal "2009-02-07 00:00:00 -0700", invoice.created_at.to_s
    assert_equal Time, invoice.created_at.class
  end

  def test_it_outputs_the_time_for_updated_at
    assert_equal "2014-03-15 00:00:00 -0600", invoice.updated_at.to_s
    assert_equal Time, invoice.updated_at.class
  end

  def test_invoice_can_ask_for_merchant
    parent = Minitest::Mock.new
    invoice = Invoice.new({:id => "1",
                      :customer_id => "2",
                      :merchant_id => "12335938",
                      :status => "pending",
                      :created_at => "2009-02-07",
                      :updated_at => "2014-03-15"
                      }, parent)
    parent.expect(:find_merchant, nil, [invoice.merchant_id])
    invoice.merchant
    assert parent.verify
  end

  def test_invoice_can_ask_for_items
    parent = Minitest::Mock.new
    invoice = Invoice.new({:id => "1",
                      :customer_id => "2",
                      :merchant_id => "12335938",
                      :status => "pending",
                      :created_at => "2009-02-07",
                      :updated_at => "2014-03-15"
                      }, parent)
    parent.expect(:find_items, nil, [invoice.id])
    invoice.items
    assert parent.verify
  end

  def test_invoice_can_ask_for_transactions
    parent = Minitest::Mock.new
    invoice = Invoice.new({:id => "1",
                      :customer_id => "2",
                      :merchant_id => "12335938",
                      :status => "pending",
                      :created_at => "2009-02-07",
                      :updated_at => "2014-03-15"
                      }, parent)
    parent.expect(:find_transactions, nil, [invoice.id])
    invoice.transactions
    assert parent.verify
  end

  def test_invoice_can_ask_for_customer
    parent = Minitest::Mock.new
    invoice = Invoice.new({:id => "1",
                      :customer_id => "2",
                      :merchant_id => "12335938",
                      :status => "pending",
                      :created_at => "2009-02-07",
                      :updated_at => "2014-03-15"
                      }, parent)
    parent.expect(:find_customer, nil, [invoice.customer_id])
    invoice.customer
    assert parent.verify
  end
end
