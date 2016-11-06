class Transaction

  attr_reader :id,
              :invoice_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at,
              :parent

  def initialize(trans_hash, transaction_repository_instance = nil)
      @id                          = trans_hash[:id].to_i
      @invoice_id                  = trans_hash[:invoice_id].to_i
      @credit_card_number          = trans_hash[:credit_card_number].to_i
      @credit_card_expiration_date = trans_hash[:credit_card_expiration_date]
      @result                      = trans_hash[:result]
      @created_at                  = determine_the_time(trans_hash[:created_at])
      @updated_at                  = determine_the_time(trans_hash[:updated_at])
      @parent                      = transaction_repository_instance
  end

  def determine_the_time(time_string)
    time = Time.new(0)
    return time if time_string == ""
    time_string = Time.parse(time_string)
  end

  def invoice
    @parent.find_invoice(@invoice_id)
  end
end
