require 'rexml/document'

module CmbPay
  class SingleOrderMessage
    attr_reader :raw_http_response, :code, :error_message,
                :bill_no,       # 定单号
                :amount,        # 实扣金额
                :accept_date,   # 受理日期
                :accept_time,   # 受理时间
                :bill_amount,   # 定单金额
                :status,        # 定单状态，0－已结帐，1－已撤销，2－部分结帐，4－未结帐，7-冻结交易-已经冻结金额已经全部结账 8-冻结交易，冻结金额只结帐了一部分
                :card_type,     # 卡类型：02：一卡通 03：信用卡
                :fee,           # 手续费
                :merchant_para, # 商户自定义参数。里面的特殊字符已经转码
                :card_no,       # 卡号（部分数字用“*”掩盖）
                :bank_seq_no    # 银行流水号
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
