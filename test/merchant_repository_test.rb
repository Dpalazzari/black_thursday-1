require_relative '../test/test_helper'
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'


class MerchantRepositoryTest < Minitest::Test
  attr_reader :merchant_repository

  def setup
    se = SalesEngine.from_csv({
              :items         => 'fixture/items_fixture_3.csv',
              :merchants     => 'fixture/merchants_fixture.csv',
              :invoices      => 'fixture/invoices_fixtures.csv',
              :invoice_items => 'fixture/invoice_item_fixture.csv',
              :transactions  => 'fixture/transaction_fixture.csv',
              :customers     => 'data/customers.csv'})
    @merchant_repository = se.merchants
  end

  def test_it_exists
    assert merchant_repository
  end

  def test_parent_is_sales_engine
    result = @merchant_repository.parent
    assert_equal SalesEngine, result.class
  end

  def test_csv_loader_loads_files
    result = merchant_repository.csv
    assert result
  end

  def test_csv_loader_loads_to_array
    result = merchant_repository.all
    assert_equal Array, result.class
  end

  def test_csv_loader_loads_correctly
    result = merchant_repository.all[0].id
    assert_equal 12334105, result
  end

  def test_find_by_id_finds_correct_pair_of_values
    merchant_repository.all
    result = merchant_repository.find_by_id(12334105)
    assert_equal "Shopin1901", result.name
  end

  def test_find_by_id_returns_correct_format
    merchant_repository.all
    result = merchant_repository.find_by_id(12334105)
    assert_equal Merchant, result.class
  end

  def test_find_by_name_finds_correct_pair_of_values
    merchant_repository.all
    result = merchant_repository.find_by_name("Shopin1901")
    assert_equal 12334105, result.id
    assert_equal "Shopin1901", result.name
    assert_equal Merchant, result.class
  end

  def test_find_all_by_name_returns_array_of_names
    merchant_repository.all
    result = merchant_repository.find_all_by_name("Shopin")
    assert_equal "Shopin1901", result.first.name
    assert_equal "Shopin1902", result.last.name
  end

  def test_it_can_find_all_by_date_created_at
    merchant_repository.all
    result = merchant_repository.find_all_by_month_created("December")
    assert_equal Time, result[0].created_at.class
  end

  def test_merchant_can_ask_se_for_items
    parent = Minitest::Mock.new
    merchants = MerchantRepository.new('fixture/merchants_fixture.csv', parent)
    parent.expect(:find_all_items_by_merchant_id, nil, [12335938])
    merchants.find_all_items_by_merchant_id(12335938)
    assert parent.verify
  end

  def test_it_can_ask_se_for_invoices
    parent = Minitest::Mock.new
    merchants = MerchantRepository.new('fixture/merchants_fixture.csv', parent)
    parent.expect(:find_all_invoices_by_merchant_id, nil, [12335938])
    merchants.find_all_invoices_by_merchant_id(12335938)
    assert parent.verify
  end

  def test_merchant_repo_can_ask_sales_engine_for_customers
    parent = Minitest::Mock.new
    merchants = MerchantRepository.new('fixture/merchants_fixture.csv', parent)
    parent.expect(:find_all_invoices_by_merchant_id, nil, [12335938])
    merchants.find_all_invoices_by_merchant_id(12335938)
    assert parent.verify
  end
end
