require 'pry'
require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_repository'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices

  def initialize(hash)
    @items     =  ItemRepository.new(hash[:items], self)
    @merchants =  MerchantRepository.new(hash[:merchants], self)
    @invoices  =  InvoiceRepository.new(hash[:invoices], self)
  end

  def self.from_csv(hash)
    SalesEngine.new(hash)
  end

  def load_items
    items.all.group_by do |item_instance|
      item_instance.merchant_id
    end
  end

  def load_invoices
    invoices.all.group_by do |invoice_instance|
      invoice_instance.merchant_id
    end
  end

  def find_all_items_by_merchant_id(id)
    @items.find_all_by_merchant_id(id)
  end

  def find_merchant_by_id(id)
    @merchants.find_by_id(id)
  end

  def find_all_invoices_by_merchant_id(id)
    @invoices.find_all_by_merchant_id(id)
  end
end
