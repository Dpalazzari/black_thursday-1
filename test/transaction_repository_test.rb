require_relative '../test/test_helper'
require_relative '../lib/transaction_repository'
require_relative '../lib/sales_engine'


class TransactionRepositoryTest < Minitest::Test

  attr_reader :transaction_repository

  def setup
    se = SalesEngine.from_csv({
              :items     => 'data/item_fixture.csv',
              :merchants => 'data/merchants_fixture.csv',
              :invoices  => 'data/invoices_fixtures.csv',
              :invoice_items => './fixture/invoice_item_fixture.csv',
              :transactions => './fixture/transaction_fixtrue.csv',
              :customers => './data/customers.csv'})
    @transaction_repository = se.transactions
  end

  def test_it_exists
    assert transaction_repository
  end

end
