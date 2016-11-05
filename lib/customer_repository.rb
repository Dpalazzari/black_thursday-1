require_relative 'customer'
require 'csv'

class CustomerRepository
  attr_reader :all,
              :csv,
              :parent

  def initialize(path, sales_engine)
    @all = []
    @parent = sales_engine
    csv_load(path)
    load_all
  end

  def csv_load(path)
    @csv = CSV.open path, headers: true, header_converters: :symbol
  end

  def load_all
    @all = csv.collect do |line|
      Customer.new(line, self)
    end
    all
  end

  # def find_by_id(id)
  #   all.find { |merchant| merchant.id == id }
  # end
  #
  # def find_by_name(full_name)
  #   all.detect do |merchant|
  #     merchant.name.upcase == full_name.upcase
  #   end
  # end
  #
  # def find_all_by_name(name_frag)
  #   all.find_all do |merchant|
  #     merchant.name.upcase.include?(name_frag.upcase)
  #   end
  # end
  #
  # def find_all_items_by_merchant_id(id)
  #   @parent.find_all_items_by_merchant_id(id)
  # end
  #
  # def find_all_invoices_by_merchant_id(id)
  #   @parent.find_all_invoices_by_merchant_id(id)
  # end

  def inspect
  "#<#{self.class} #{@all.size} rows>"
  end
end
