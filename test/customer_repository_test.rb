require_relative '../test/test_helper'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customers

  def setup
    se = SalesEngine.from_csv({
              :items         => 'fixture/items_fixture_3.csv',
              :merchants     => 'fixture/merchants_fixture.csv',
              :invoices      => 'fixture/invoices_fixtures.csv',
              :invoice_items => 'fixture/invoice_item_fixture.csv',
              :transactions  => 'fixture/transaction_fixture.csv',
              :customers     => 'data/customers.csv'})
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
    result = customers.find_all_by_first_name("Ramona")
    assert_equal Array, result.class
    assert_equal 10, result[0].id
  end

  def test_find_all_by_first_name_returns_multiple_customers
    result = customers.find_all_by_first_name("oe")
    assert_equal Array, result.class
    assert_equal 8, result.count
  end

  def test_find_all_by_last_name
    result = customers.find_all_by_last_name("Reynolds")
    assert_equal Array, result.class
    assert_equal 10, result[0].id
    assert_equal "Ramona", result[0].first_name
  end

  def test_find_all_by_last_name_can_return_multiple_customers
    result = customers.find_all_by_last_name("cH")
    assert_equal Array, result.class
    assert_equal 17, result[0].id
  end
end
