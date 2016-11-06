require_relative '../lib/transaction'
require 'csv'

class TransactionRepository

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
    @all = csv.collect { |line| Transaction.new(line, self) }
  end

  def find_by_id(id)
    all.detect { |transaction| transaction.id == id }
  end

  def find_all_by_invoice_id(inv_id)
    all.find_all { |transaction| transaction.invoice_id == inv_id }
  end

  def find_all_by_credit_card_number(credit_card_number)
    all.find_all do |transaction|
      transaction.credit_card_number == credit_card_number
    end
  end

  def find_all_by_result(word)
    all.find_all { |transaction| transaction.result == word }
  end

  def find_invoice(id)
    @parent.find_invoice_by_id(id)
  end

  def inspect
    "#<#{self.class} #{@all.size} rows>"
  end
end
