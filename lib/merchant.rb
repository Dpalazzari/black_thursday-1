require 'pry'
require 'csv'

class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at,
              :parent

  def initialize(hash, merchant_repository_instance = nil)
    @id         = hash[:id]
    @name       = hash[:name]
    @created_at = determine_the_time(hash[:created_at])
    @updated_at = determine_the_time(hash[:updated_at])
    @parent     = merchant_repository_instance
  end

  def determine_the_time(time)
    time = Time.parse(time)
  end

  def items
    @parent.find_all_items_by_merchant_id(@id)
  end

  def invoices
    @parent.find_all_invoices_by_merchant_id(@id)
  end

  def customers
    @parent.find_customers_by_id(@id)
  end
end
