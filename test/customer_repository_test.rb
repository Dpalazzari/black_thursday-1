require_relative '../test/test_helper'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customers

  def setup
    se = SalesEngine.from_csv({
      :items         => 'data_min/items.csv',
      :merchants     => 'data_min/merchants.csv',
      :invoices      => 'data_min/invoices.csv',
      :invoice_items => 'data_min/invoice_items.csv',
      :transactions  => 'data_min/transactions.csv',
      :customers     => 'data_min/customers.csv'})
    @customers = se.customers
  end

  def test_csv_load_loads_file
    result = customers.csv
    assert_equal CSV, result.class
  end

  def test_load_all_loads_customers
    result = customers.all
    assert_equal Array, result.class
    assert_equal Customer, result.first.class
    assert_equal 1, result.first.id
  end

  def test_find_by_id_returns_correct_customer
    result = customers.find_by_id(1)
    assert_equal Customer, result.class
    assert_equal 1, result.id
  end

  def test_find_all_by_first_name
    result = customers.find_all_by_first_name("Lindsay")
    assert_equal Array, result.class
    assert_equal 15, result[0].id
  end

  def test_find_all_by_first_name_returns_multiple_customers
    result = customers.find_all_by_first_name("george")
    assert_equal Array, result.class
    assert_equal 2, result.count
  end

  def test_find_all_by_last_name
    result = customers.find_all_by_last_name("Bluth")
    assert_equal Array, result.class
    assert_equal 11, result[0].id
    assert_equal "GeorgeSr", result[0].first_name
  end

  def test_find_all_by_last_name_can_return_multiple_customers
    result = customers.find_all_by_last_name("Bluth")
    assert_equal Array, result.class
    assert_equal 11, result[0].id
  end


  def test_invoice_can_ask_for_customer
    parent = Minitest::Mock.new
    customers = CustomerRepository.new('data/customers.csv', parent)
    parent.expect(:find_merchants_by_customer_id, nil, [1])
    customers.find_merchants_by_customer_id(1)
    assert parent.verify
  end
end
