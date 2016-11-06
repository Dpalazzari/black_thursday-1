require 'pry'

class Invoice

  attr_reader :id,
              :customer_id,
              :merchant_id,
              :status,
              :created_at,
              :updated_at,
              :parent

  def initialize(invoice_hash, invoice_repository = nil)
    @id           = invoice_hash[:id].to_i
    @customer_id  = invoice_hash[:customer_id].to_i
    @merchant_id  = invoice_hash[:merchant_id].to_i
    @status       = invoice_hash[:status].to_sym
    @created_at   = determine_the_time(invoice_hash[:created_at])
    @updated_at   = determine_the_time(invoice_hash[:updated_at])
    @parent       = invoice_repository
  end

  def determine_the_time(time)
    time = Time.parse(time)
  end

  def merchant
    @parent.find_merchant(@merchant_id)
  end

  def items
    @parent.find_items(@id)
  end

  def transactions
    @parent.find_transactions(@id)
  end

  def customer
    @parent.find_customer(@customer_id)
  end

  def is_paid_in_full?
    matching_transactions = @parent.find_transactions(@id)
    result = matching_transactions.map do |transaction|
      transaction.result == "success"
    end
    if result.include?(false) || result.count == 0
      return false
    else
      return true
    end
  end

  def invoice_items
    @parent.find_invoice_items_by_invoice_id(@id)
  end

  def total
    if is_paid_in_full?
      invoice_items.compact.inject(0) do |result, element|
        result += element.unit_price * element.quantity
      end
    end
  end
end
