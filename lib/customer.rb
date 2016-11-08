
class Customer
  attr_reader :id,
              :first_name,
              :last_name,
              :created_at,
              :updated_at,
              :parent

  def initialize(customer_hash, customer_repository = nil)
    @id           = customer_hash[:id].to_i
    @first_name   = customer_hash[:first_name]
    @last_name    = customer_hash[:last_name]
    @created_at   = determine_the_time(customer_hash[:created_at].to_s)
    @updated_at   = determine_the_time(customer_hash[:updated_at].to_s)
    @parent       = customer_repository
  end

  def determine_the_time(time_string)
    time = Time.new(0)
    return time if time_string == ""
    time_string = Time.parse(time_string)
  end

  def merchants
    @parent.find_merchants_by_customer_id(@id)
  end
end
