require 'pry'
require 'bigdecimal'
require 'time'

class InvoiceItem
  attr_reader :id,
              :item_id,
              :invoice_id,
              :quantity,
              :unit_price,
              :created_at,
              :updated_at,
              :parent

  def initialize(invoice_item_hash, invoice_item_repository_instance = nil)
    @id          = invoice_item_hash[:id].to_i
    @item_id     = invoice_item_hash[:item_id].to_i
    @invoice_id  = invoice_item_hash[:invoice_id].to_i
    @quantity    = invoice_item_hash[:quantity].to_i
    @unit_price  = find_unit_price(invoice_item_hash[:unit_price])
    @created_at  = determine_the_time(invoice_item_hash[:created_at])
    @updated_at  = determine_the_time(invoice_item_hash[:updated_at])
    @parent      = invoice_item_repository_instance
  end

  def find_unit_price(price)
    if unit_price == ""
      unit_price = BigDecimal.new(0)
    else
      unit_price = BigDecimal.new(price) / 100
    end
    return unit_price
  end

  def unit_price_to_dollars(unit_price)
    @unit_price.to_f
  end

  def determine_the_time(time_string)
    time = Time.new(0)
    return time if time_string == ""
    time_string = Time.parse(time_string)
  end
  #
  # def merchant
  #   @parent.find_merchant(@merchant_id)
  # end
end
