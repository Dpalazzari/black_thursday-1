require_relative '../test/test_helper'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test
  attr_reader :customer

  def setup
    @customer = Customer.new({
      :id         => "6",
      :first_name => "Joan",
      :last_name  => "Clarke",
      :created_at => Time.now,
      :updated_at => Time.now
      })
  end

  def test_initializes_with_given_hash
    assert_equal Fixnum, customer.id.class
    assert_equal 6, customer.id
    assert_equal String, customer.first_name.class
    assert_equal "Joan", customer.first_name
    assert_equal String, customer.last_name.class
    assert_equal "Clarke", customer.last_name
    assert_equal Time, customer.created_at.class
    assert_equal Time, customer.updated_at.class
  end
end
