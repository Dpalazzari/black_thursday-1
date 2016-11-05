require_relative '../test/test_helper'
require_relative '../lib/customer_repository'
require_relative '../lib/sales_engine'

class CustomerRepositoryTest < Minitest::Test
  attr_reader :customers

  def setup
    se = SalesEngine.from_csv({
      :items         => 'data/item_fixture.csv',
      :merchants     => 'data/merchants_fixture.csv',
      :invoices      => 'data/invoices_fixtures.csv',
      :invoice_items => 'fixture/invoice_item_fixture.csv',
      :customers     => 'fixture/customer_fixture.csv'})
    @customers = se.customers
  end
end
