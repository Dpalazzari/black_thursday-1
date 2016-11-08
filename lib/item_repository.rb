require 'pry'
require 'csv'
require_relative '../lib/item'

class ItemRepository

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
      Item.new(line, self)
    end
    all
  end

  def find_by_id(id)
    all.find { |item| item.id == id }
  end

  def find_by_name(name)
    all.find do |item|
      item.name.upcase.include?(name.upcase)
    end
  end

  def find_all_with_description(description)
    all.find_all do |item|
      item.description.upcase.include?(description.upcase)
    end
  end

  def find_all_by_price(price)
    all.find_all do |item|
      item.unit_price == price
    end
  end

  def find_all_by_price_in_range(price_range)
    all.find_all do |item|
      price_range.include?(item.unit_price)
    end
  end

  def find_all_by_merchant_id(id)
    all.find_all do |item|
      item.merchant_id == id
    end
  end

  def find_merchant(id)
    @parent.find_merchant_by_id(id)
  end

  def inspect
  end
end
