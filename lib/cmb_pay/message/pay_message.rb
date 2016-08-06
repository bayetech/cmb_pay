module CmbPay
  class PayMessage
    attr_accessor :succeed        # 消息成功失败,成功为'Y',失败为'N'
    attr_accessor :co_no          # 商户号，6位长数字，由银行在商户开户时确定
    attr_accessor :bill_no        # 订单号(由支付命令送来)；
    attr_accessor :amount         # 实际支付金额(由支付命令送来)
    attr_accessor :date           # 订单下单日期(由支付命令送来)
    attr_accessor :merchant_para  # 商户自定义传递参数(由支付命令送来)
    attr_accessor :msg            # 银行通知用户支付结构消息
    attr_accessor :discount_flag  # 当前订单是否有优惠，Y:有优惠 N：无优惠。
    attr_accessor :discount_amt   # 优惠金额，格式：xxxx.xx，当有优惠的时候，
                                  # 实际用户支付的是amount - discount_amt的金额到商户账号。

    attr_accessor :branch_id      # 分行号
    attr_accessor :bank_date      # 银行主机交易日期
    attr_accessor :bank_serial_no # 银行流水号

    attr_accessor :signature      # 通知命令签名

    attr_reader   :query_string   # 原始的query_string

    def initialize(query_string)
      query_string = URI.encode_www_form(query_string) if query_string.is_a? Hash
      @query_string = query_string

      params = URI.decode_www_form(query_string).to_h

      @succeed = params['Succeed']
      @co_no = params['CoNo']
      @bill_no = params['BillNo']
      @amount = params['Amount']
      @date = params['Date']
      @merchant_para = params['MerchantPara']
      @msg = params['Msg']
      @discount_flag = params['DiscountFlag']
      @discount_amt = params['DiscountAmt']

      # 银行通知用户的支付结果消息。信息的前38个字符格式为：4位分行号＋6位商户号＋8位银行接受交易的日期＋20位银行流水号；
      # 可以利用交易日期＋银行流水号＋订单号对该订单进行结帐处理
      msg = params['Msg'][0..37]
      @branch_id = msg[0..3]
      @co_no ||= msg[4..9]
      @bank_date = msg[10..17]
      @bank_serial_no = msg[18..37]

      @signature = params['Signature']
    end

    def valid?
      Sign::Sha1WithRsa.verify(query_string)
    end

    def succeed?
      succeed == 'Y'
    end

    def discount?
      discount_flag == 'Y'
    end

    def amount_cents
      (amount.to_f * 100).to_i
    end

    def discount_amount_cents
      (discount_amt.to_f * 100).to_i
    end

    def order_date
      Date.strptime(date, '%Y%m%d')
    end

    def payment_date
      Date.strptime(bank_date, '%Y%m%d')
    end

    def merchant_params
      URI.decode_www_form(merchant_para.tr('|', '&')).to_h
    end
  end
end
