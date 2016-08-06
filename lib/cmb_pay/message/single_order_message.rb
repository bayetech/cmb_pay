require 'rexml/document'

module CmbPay
  class SingleOrderMessage
    attr_accessor :raw_http_response, :code, :error_message, :bill_no, :amount, :accept_date, :accept_time,
                  :bill_amount, :status, :card_type, :fee, :merchant_para, :card_no, :bank_seq_no
    def initialize(http_response)
      @raw_http_response = http_response
      return unless http_response.code == 200

      document_root = REXML::Document.new(http_response.body.to_s).root
      head = document_root.elements['Head']
      @code          = head.elements['Code'].text
      @error_message = head.elements['ErrMsg'].text
      return unless succeed?

      body = document_root.elements['Body']
      @bill_no       = body.elements['BillNo'].text
      @amount        = body.elements['Amount'].text
      @accept_date   = body.elements['AcceptDate'].text
      @accept_time   = body.elements['AcceptTime'].text
      @bill_amount   = body.elements['BillAmount'].text
      @status        = body.elements['Status'].text
      @card_type     = body.elements['CardType'].text
      @fee           = body.elements['Fee'].text
      @merchant_para = body.elements['MerchantPara'].text
      @card_no       = body.elements['CardNo'].text
      @bank_seq_no   = body.elements['BankSeqNo'].text
    end

    def succeed?
      code.nil? && error_message.nil?
    end
  end
end
