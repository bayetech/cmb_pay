require 'rexml/document'

module CmbPay
  class RefundOrderMessage
    attr_reader :raw_http_response, :code, :error_message,
                :refund_no,   # 银行退款流水号
                :bank_seq_no, # 银行流水号
                :amount,      # 退款金额
                :date,        # 银行交易日期YYYYMMDD
                :time         # 银行交易时间hhmmss

    def initialize(http_response)
      @raw_http_response = http_response
      return unless http_response.code == 200

      document_root = REXML::Document.new(http_response.body.to_s).root
      head = document_root.elements['Head']
      @code          = head.elements['Code'].text
      @error_message = head.elements['ErrMsg'].text
      return unless succeed?

      body = document_root.elements['Body']
      @refund_no   = body.elements['RefundNo'].text
      @bank_seq_no = body.elements['BankSeqNo'].text
      @amount      = body.elements['Amount'].text
      @date        = body.elements['Date'].text
      @time        = body.elements['Time'].text
    end

    def succeed?
      code.nil? && error_message.nil?
    end
  end
end
