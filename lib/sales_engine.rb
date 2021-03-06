require 'csv'
require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice_item_repository'
require_relative '../lib/transaction_repository'
require_relative '../lib/customer_repository'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices,
              :invoice_items,
              :transactions,
              :customers

  def initialize(hash)
    @items         ||=  ItemRepository.new(hash[:items], self)
    @merchants     ||=  MerchantRepository.new(hash[:merchants], self)
    @invoices      ||=  InvoiceRepository.new(hash[:invoices], self)
    @invoice_items ||=  InvoiceItemRepository.new(hash[:invoice_items], self)
    @transactions  ||=  TransactionRepository.new(hash[:transactions], self)
    @customers     ||=  CustomerRepository.new(hash[:customers], self)
  end

  def self.from_csv(hash)
    SalesEngine.new(hash)
  end

  def load_items
    items.all.group_by { |item_instance| item_instance.merchant_id}
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

  def find_items_by_invoice_id(id)
    items = @invoice_items.find_all_by_invoice_id(id)
    items.map do |invoice_item|
      @items.find_by_id(invoice_item.item_id)
    end
  end

  def find_invoice_items_by_invoice_id(id)
    @invoice_items.find_all_by_invoice_id(id)
  end

  def find_items_by_item_id(item_id)
    @items.find_by_id(item_id)
  end

  def find_transactions_by_invoice_id(id)
    @transactions.find_all_by_invoice_id(id)
  end

  def find_customer_by_id(id)
    @customers.find_by_id(id)
  end

  def find_invoice_by_id(id)
    @invoices.find_by_id(id)
  end

  def find_customers_by_merchant_id(id)
    matching_invoices = @invoices.find_all_by_merchant_id(id)
    matching_invoices.map do |invoice|
      @customers.find_by_id(invoice.customer_id)
    end.uniq
  end

  def find_merchants_by_customer_id(id)
    matching_invoices = @invoices.find_all_by_customer_id(id)
    matching_invoices.map do |invoice|
      @merchants.find_by_id(invoice.merchant_id)
    end.uniq.compact
  end

end
