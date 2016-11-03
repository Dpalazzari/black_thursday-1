require_relative 'merchant'
require 'csv'

class MerchantRepository
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
    csv.each do |line|
      all << Merchant.new({:id => line[:id].to_i, :name => line[:name]}, self)
    end
    all
  end

  def find_by_id(id)
    all.find { |merchant| merchant.id == id }
  end

  def find_by_name(full_name)
    all.detect do |merchant|
      merchant.name.upcase == full_name.upcase
    end
  end

  def find_all_by_name(name_frag)
    all.find_all do |merchant|
      merchant.name.upcase.include?(name_frag.upcase)
    end
  end

  def find_all_by_merchant_id(id)
    @parent.find_all_by_merchant_id(id)
  end

  def inspect
  "#<#{self.class} #{@all.size} rows>"
  end
end
