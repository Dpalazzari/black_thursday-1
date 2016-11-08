require_relative '../lib/invoice'
require 'csv'

class InvoiceRepository

  attr_reader :csv, :all, :parent

  def initialize(path, sales_engine = nil)
    @parent = sales_engine
    @all    = []
    csv_path(path)
    load_all
  end

  def csv_path(path)
    @csv = CSV.open path, headers: true, header_converters: :symbol
  end

  def load_all
    csv.each {|line| @all << Invoice.new(line, self)}
  end

  def find_by_id(id)
    all.find { |invoice| invoice.id == id }
  end

  def find_all_by_customer_id(id)
    all.find_all { |invoice| invoice.customer_id == id }
  end

  def find_all_by_merchant_id(id)
    all.find_all { |invoice| invoice.merchant_id == id }
  end

  def find_all_by_status(status)
    all.find_all { |invoice| invoice.status == status }
  end

  def find_all_by_date(date)
    all.find_all do |invoice|
      invoice.created_at.strftime("%Y-%m-%d") == date.strftime("%Y-%m-%d")
    end
  end

  def find_merchant(id)
    @parent.find_merchant_by_id(id)
  end

  def find_items(id)
    @parent.find_items_by_invoice_id(id)
  end

  def find_transactions(id)
    @parent.find_transactions_by_invoice_id(id)
  end

  def find_customer(id)
    @parent.find_customer_by_id(id)
  end

  def find_invoice_items_by_invoice_id(id)
    @parent.find_invoice_items_by_invoice_id(id)
  end

  def inspect
  end
end
