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
end
