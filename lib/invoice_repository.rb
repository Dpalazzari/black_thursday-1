require_relative '../lib/invoice'
require 'csv'

class InvoiceRepository

  attr_reader :csv, :all, :parent

  def initialize(path, sales_engine = nil)
    @parent = sales_engine
    @all = []
    csv_path(path)
    load_all
  end

  def csv_path(path)
    @csv = CSV.open path, headers: true, header_converters: :symbol
  end

  def load_all
    csv.each do |line|
      @all << Invoice.new(line, self)
    end
    all
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

  def find_merchant(id)
    @parent.find_merchant_by_id(id)
  end
end
