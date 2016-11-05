require_relative 'customer'
require 'csv'

class CustomerRepository

  attr_reader :csv,
              :all,
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

  def find_by_id(id)
    all.find { |customer| customer.id == id }
  end

  def find_all_by_first_name(name)
    all.find_all { |customer| customer.first_name == name }
  end

  def find_all_by_last_name(last)
    all.find_all { |cutomer| customer.last_name == last }
  end

  def inspect
  "#<#{self.class} #{@all.size} rows>"
  end
end
