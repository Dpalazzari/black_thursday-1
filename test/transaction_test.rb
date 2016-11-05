require_relative 'test_helper'
require_relative '../lib/transaction.rb'


class TransactionTest < Minitest::Test

  attr_reader :transaction

  def setup
    @transaction = Transaction.new({
      :id                 => "6",
      :invoice_id         => "8",
      :credit_card_number => "4242424242424242",
      :credit_card_expiration_date   => "0220",
      :result             => "success",
      :created_at         => "2012-03-27 14:54:09 UTC",
      :updated_at         => "2012-03-27 14:54:09 UTC"
      })
  end

  def test_it_exists
    assert transaction
  end

  def test_it_initializes_with_proper_hash_values
    assert 6, transaction.id
    assert Integer, transaction.id.class
    assert 8, transaction.invoice_id
    assert Integer, transaction.invoice_id.class
    assert "4242424242424242", transaction.credit_card_number
    assert "success", transaction.result
  end

  def test_it_returns_the_proper_time_created_at
    assert_equal "2012-03-27 14:54:09 UTC", transaction.created_at.to_s
    assert_equal Time, transaction.created_at.class
  end

  def test_it_returns_the_proper_time_updated_at
    assert_equal "2012-03-27 14:54:09 UTC", transaction.updated_at.to_s
    assert_equal Time, transaction.updated_at.class
  end

  def test_invoice_can_ask_for_merchant
    skip
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

end
