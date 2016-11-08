require_relative '../test/test_helper'
require_relative '../lib/item_repository'
require_relative '../lib/sales_engine'


class ItemRepositoryTest < Minitest::Test
  attr_reader :item_repository
  def setup
    se = SalesEngine.from_csv({
      :items         => 'data_min/items.csv',
      :merchants     => 'data_min/merchants.csv',
      :invoices      => 'data_min/invoices.csv',
      :invoice_items => 'data_min/invoice_items.csv',
      :transactions  => 'data_min/transactions.csv',
      :customers     => 'data_min/customers.csv'})
    @item_repository = se.items
  end

  def test_it_exists
    assert item_repository
  end

  def test_it_reads_a_csv_file
    output = item_repository.csv
    assert output
  end

  def test_it_saves_everything_as_a_giant_array
    output = item_repository.all
    assert_equal Array, output.class
  end

  def test_all
    output = item_repository.all.count
    assert_equal 67, output
  end

  def test_it_puts_the_id_in_the_all_array
    output = item_repository.all[0].id
    assert_equal 1, output
  end

  def test_it_puts_the_name_in_the_all_array
    output = item_repository.all[0].name
    assert_equal "The George Daddy", output
  end

  def test_it_puts_the_merchant_id_in_the_all_array
    output = item_repository.all[0].merchant_id
    assert_equal 1, output
  end

  def test_it_puts_the_unit_price_in_the_all_array
    output = item_repository.all[0].unit_price
    assert_equal 15.02, output.to_f
  end

  def test_find_by_id_finds_proper_values
    item_repository.all
    output = item_repository.find_by_id(7).name
    assert_equal "the G.O.B.", output
  end

  def test_find_by_id_can_be_used_to_retrieve_price_in_right_class
    item_repository.all
    output = item_repository.find_by_id(7).unit_price
    assert_equal BigDecimal, output.class
  end

  def test_find_by_id_can_retrieve_unit_price
    item_repository.all
    output = item_repository.find_by_id(8).unit_price
    assert_equal 18.55, output
  end

  def test_find_by_id_works_with_proper_format
    item_repository.all
    output = item_repository.find_by_id(5)
    assert_equal Item, output.class
  end

  def test_find_by_name_works_with_proper_format
    item_repository.all
    output = item_repository.find_by_name("The George Daddy")
    assert_equal 1, output.id
    assert_equal 1, output.merchant_id
    assert_equal 15.02, output.unit_price
  end

  def test_find_all_with_description
    item_repository.all
    output = item_repository.find_all_with_description("banana")
    assert_equal 1, output.first.id
    assert_equal 1, output.first.merchant_id
    assert_equal 15.02, output.first.unit_price.to_f
    assert_equal "The George Daddy", output.first.name
  end

  def test_find_all_by_price
    item_repository.all
    output = item_repository.find_all_by_price(15.02)
    assert_equal Array, output.class
    assert_equal 1, output.first.id
    assert_equal 1, output.first.merchant_id
  end

  def test_find_all_by_price_range
    item_repository.all
    output = item_repository.find_all_by_price_in_range(100.0..200.0)
    assert_equal Array, output.class
    assert_equal 36, output.first.id
  end

  def test_find_by_merchant_id
    item_repository.all
    output = item_repository.find_all_by_merchant_id(3)
    assert_equal Array, output.class
    assert_equal 8, output.first.id
    assert_equal "the simple simon", output.first.name
    assert_equal 18.55, output.first.unit_price.to_f
  end

  def test_item_can_ask_for_merchant
    parent = Minitest::Mock.new
    items = ItemRepository.new('fixture/item_fixture.csv', parent)
    parent.expect(:find_merchant_by_id, nil, [12335938])
    items.find_merchant(12335938)
    assert parent.verify
  end
end
