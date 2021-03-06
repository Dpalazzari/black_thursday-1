require_relative '../test/test_helper'
require_relative '../lib/transaction_repository'
require_relative '../lib/sales_engine'


class TransactionRepositoryTest < Minitest::Test

  attr_reader :transaction_repository

  def setup
    se = SalesEngine.from_csv({
      :items         => 'data_min/items.csv',
      :merchants     => 'data_min/merchants.csv',
      :invoices      => 'data_min/invoices.csv',
      :invoice_items => 'data_min/invoice_items.csv',
      :transactions  => 'data_min/transactions.csv',
      :customers     => 'data_min/customers.csv'})
    @transaction_repository = se.transactions
  end

  def test_it_exists
    assert transaction_repository
  end

  def test_it_reads_a_csv_file
    output = transaction_repository.csv
    assert output
  end

  def test_it_saves_everything_as_a_giant_array
    output = transaction_repository.all
    assert_equal Array, output.class
  end

  def test_all
    output = transaction_repository.all.count
    assert_equal 67, output
  end

  def test_it_puts_the_id_in_the_all_array
    output = transaction_repository.all[0].id
    assert_equal 1, output
  end

  def test_it_puts_the_invoice_id_in_the_all_array
    output = transaction_repository.all[0].invoice_id
    assert_equal 30, output
  end

  def test_it_puts_the_credit_card_info_in_the_all_array
    output = transaction_repository.all[0].credit_card_number
    assert_equal 4068631943231473, output
    result = transaction_repository.all[0].credit_card_expiration_date
    assert_equal "0217", result
  end

  def test_it_stores_the_time_in_the_proper_format_in_the_all_array
    output = transaction_repository.all[0].created_at
    assert_equal Time, output.class
    result = transaction_repository.all[0].updated_at
    assert_equal Time, result.class
  end

  def test_it_can_find_a_transaction_by_id
    output = transaction_repository.find_by_id(1)
    assert_equal Transaction, output.class
    assert_equal 30, output.invoice_id
    assert_equal "success", output.result
  end

  def test_it_cam_find_a_transaction_by_invoice_id
    output = transaction_repository.find_all_by_invoice_id(1)
    assert_equal Array, output.class
    assert_equal 30, output[0].id
    assert_equal 4619850044750256, output[0].credit_card_number
  end

  def test_it_can_find_a_transaction_by_credit_card_number
    output = transaction_repository.find_all_by_credit_card_number(4068631943231473)
    assert_equal Array, output.class
    assert_equal 1, output[0].id
    assert_equal 30, output[0].invoice_id
    assert_equal Time, output[0].created_at.class
    assert_equal Time, output[0].updated_at.class
  end

  def test_it_can_find_a_transaction_by_result
    output = transaction_repository.find_all_by_result("success")
    assert_equal Array, output.class
    assert_equal 1, output[0].id
    assert_equal 30, output[0].invoice_id
    assert_equal Time, output[0].created_at.class
    assert_equal Time, output[0].updated_at.class
  end

  def test_transaction_can_ask_for_invoice
    parent = Minitest::Mock.new
    transactions = TransactionRepository.new('fixture/transaction_fixture.csv', parent)
    parent.expect(:find_invoice_by_id, nil, [1])
    transactions.find_invoice(1)
    assert parent.verify
  end

end
