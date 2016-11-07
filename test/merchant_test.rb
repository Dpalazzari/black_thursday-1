require_relative '../test/test_helper'
require_relative '../lib/merchant.rb'
require_relative '../lib/item'


class MerchantTest < Minitest::Test
  attr_reader :merchant

  def setup
    @merchant = Merchant.new({:id => 5,
                              :name => "Turing School",
                              :created_at => "2010-12-10",
                              :updated_at => "2011-12-04"})
  end

  def test_it_exists
    assert merchant
  end

  def test_it_what_the_class_is
    assert_equal Merchant, merchant.class
  end

  def test_it_has_id
    assert merchant.id
    assert_equal 5, merchant.id
  end

  def test_it_outputs_the_correct_time_created_at
    assert merchant.created_at
    assert_equal Time, merchant.created_at.class
  end

  def test_it_outputs_the_correct_time_updated_at
    assert merchant.updated_at
    assert_equal Time, merchant.updated_at.class
  end

  def test_id_is_integer
    assert_equal Fixnum, merchant.id.class
  end

  def test_it_has_name
    assert merchant.name
    assert_equal "Turing School", merchant.name
  end

  def test_merchant_can_ask_mr_for_invoices
    parent = Minitest::Mock.new
    merchant = Merchant.new({:id => 5,
                            :name => "Turing School",
                            :created_at => "2010-12-10",
                            :updated_at => "2011-12-04"}, parent)
    parent.expect(:find_all_invoices_by_merchant_id, nil, [merchant.id])
    merchant.invoices
    assert parent.verify
  end

  def test_merchant_can_ask_mr_for_items
    parent = Minitest::Mock.new
    merchant = Merchant.new({:id => 5,
                            :name => "Turing School",
                            :created_at => "2010-12-10",
                            :updated_at => "2011-12-04"}, parent)
    parent.expect(:find_all_items_by_merchant_id, nil, [merchant.id])
    merchant.items
    assert parent.verify
  end

  def test_merchant_can_ask_mr_for_customers
    parent = Minitest::Mock.new
    merchant = Merchant.new({:id => 5,
                            :name => "Turing School",
                            :created_at => "2010-12-10",
                            :updated_at => "2011-12-04"}, parent)
    parent.expect(:find_customers_by_id, nil, [merchant.id])
    merchant.customers
    assert parent.verify
  end

end
