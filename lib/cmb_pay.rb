require 'date'
require 'uri'
require 'http' # https://github.com/httprb/http
require 'cmb_pay/version'
require 'cmb_pay/util'
require 'cmb_pay/sign'
require 'cmb_pay/merchant_code'
require 'cmb_pay/message/pay'
require 'cmb_pay/service'

module CmbPay
  class << self
    attr_accessor :branch_id          # 开户分行号
    attr_accessor :co_no              # 支付商户号/收单商户号
    attr_accessor :co_key             # 商户校验码/商户密钥，测试环境为空
    attr_accessor :mch_no             # 协议商户企业编号，或者说是8位虚拟企业网银编号
    attr_accessor :operator           # 操作员号，一般是9999
    attr_accessor :operator_password  # 操作员的密码，默认是支付商户号，但建议修改。
    attr_accessor :expire_in_minutes  # 会话有效时间
    attr_accessor :environment        # 调用的招商银行支付环境，默认生产，测试填test
    attr_accessor :default_payee_id   # 默认收款方的用户标识
  end
  @co_key = ''
  @mch_no = ''
  @operator = '9999'
  @operator_password = ''
  @expire_in_minutes = 30
  @environment = :production

  SUPPORTED_BANK = {
    '招商银行' => nil,
    '兴业银行' => 309,
    '中信银行' => 302,
    '中国民生银行' => 305,
    '光大银行' => 303,
    '华夏银行' => 304,
    '北京农村商业银行' => 1418,
    '深圳发展银行' => 307,
    '中国银行' => 104,
    '北京银行' => 403,
    '中国邮政储蓄银行' => 100,
    '上海浦东发展银行' => 310,
    '东亚银行' => 2502,
    '广东发展银行' => 306,
    '南京银行' => 424,
    '上海交通银行' => 301,
    '平安银行' => 410,
    '中国工商银行' => 102,
    '杭州银行' => 423,
    '中国建设银行' => 105,
    '宁波银行' => 408,
    '中国农业银行' => 103,
    '浙商银行' => 316,
    '渤海银行' => 318,
    '上海农村商业银行' => 402,
    '上海银行' => 313
  }.freeze

  def self.uri_of_pre_pay_euserp(payer_id:, bill_no:, amount_in_cents:, merchant_url:, merchant_para: nil,
                                 protocol:, merchant_ret_url:, merchant_ret_para: nil,
                                 options: {})
    generate_pay_link_of('PrePayEUserP',
                         payer_id, bill_no, amount_in_cents, merchant_url, merchant_para,
                         protocol, merchant_ret_url, merchant_ret_para, nil,
                         options)
  end

  def self.uri_of_pre_pay_c2(bill_no:, amount_in_cents:, merchant_url:, merchant_para: nil,
                             merchant_ret_url:, merchant_ret_para: nil, card_bank: nil,
                             options: {})
    generate_pay_link_of('PrePayC2',
                         nil, bill_no, amount_in_cents, merchant_url, merchant_para,
                         nil, merchant_ret_url, merchant_ret_para, card_bank,
                         options)
  end

  def self.uri_of_pre_pay_wap(bill_no:, amount_in_cents:, merchant_url:, merchant_para: nil,
                              card_bank: nil,
                              options: {})
    generate_pay_link_of('PrePayWAP',
                         nil, bill_no, amount_in_cents, merchant_url, merchant_para,
                         nil, nil, nil, card_bank,
                         options)
  end

  def self.pay_message(query_string)
    CmbPay::Message::Pay.new query_string
  end

  # 退款接口
  def self.refund_no_dup(bill_no:, refund_no:, refund_amount_in_cents:, memo:,
                         bill_date: nil, operator: nil, operator_password: nil,
                         branch_id: nil, co_no: nil, co_key: nil, time_stamp: nil)
    refund_in_yuan, refund_in_cent = refund_amount_in_cents.to_i.divmod(100)
    refund_amount = "#{refund_in_yuan}.#{format('%02d', refund_in_cent)}"
    desc = memo.encode(xml: :text)
    bill_date = Time.now.strftime('%Y%m%d') if bill_date.nil?
    head_inner_xml = build_direct_request_x_head('Refund_No_Dup', branch_id, co_no, time_stamp,
                                                 with_operator: true, operator: operator, operator_password: operator_password)
    body_inner_xml = "<Date>#{bill_date}</Date><BillNo>#{Util.cmb_bill_no(bill_no)}</BillNo><RefundNo>#{Util.cmb_bill_no(refund_no)}</RefundNo><Amount>#{refund_amount}</Amount><Desc>#{desc}</Desc>"
    hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
  end

  # 单笔定单查询接口
  def self.query_single_order(bill_no:, trade_date: nil,
                              branch_id: nil, co_no: nil, co_key: nil, time_stamp: nil)
    trade_date = Time.now.strftime('%Y%m%d') if trade_date.nil?
    head_inner_xml = build_direct_request_x_head('QuerySingleOrder', branch_id, co_no, time_stamp)
    body_inner_xml = "<Date>#{trade_date}</Date><BillNo>#{Util.cmb_bill_no(bill_no)}</BillNo>"
    hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
  end

  # 商户入账查询接口
  # pos: 当<QryLopFlg>Y</QryLopFlg>续传标记为Y时（表示仍有后续的通讯包，采用多次通讯方式续传时使用)
  #      填写<QryLopBlk>续传包请求数据</QryLopBlk>中的数据
  def self.query_transact(begin_date:, end_date:, count:, operator: nil, pos: nil,
                          branch_id: nil, co_no: nil, co_key: nil, time_stamp: nil)
    head_inner_xml = build_direct_request_x_head('QueryTransact', branch_id, co_no, time_stamp)
    body_inner_xml = build_direct_request_x_query_body(begin_date, end_date, count, operator, pos)
    hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
  end

  # 按商户日期查询已结账订单接口
  def self.query_settled_order_by_merchant_date(begin_date:, end_date:, count:, operator: nil, pos: nil,
                                                branch_id: nil, co_no: nil, co_key: nil, time_stamp: nil)
    head_inner_xml = build_direct_request_x_head('QuerySettledOrderByMerchantDate', branch_id, co_no, time_stamp)
    body_inner_xml = build_direct_request_x_query_body(begin_date, end_date, count, operator, pos)
    hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
  end

  # 按结账日期查询已结账订单接口
  def self.query_settled_order_by_settled_date(begin_date:, end_date:, count:, operator: nil, pos: nil,
                                               branch_id: nil, co_no: nil, co_key: nil, time_stamp: nil)
    head_inner_xml = build_direct_request_x_head('QuerySettledOrderBySettledDate', branch_id, co_no, time_stamp)
    body_inner_xml = build_direct_request_x_query_body(begin_date, end_date, count, operator, pos)
    hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
  end

  private_class_method

  def self.build_direct_request_x_head(cmb_command, branch_id, co_no, time_stamp,
                                       with_operator: false, operator: nil, operator_password: nil)
    branch_id = CmbPay.branch_id if branch_id.nil?
    co_no = CmbPay.co_no if co_no.nil?
    if with_operator
      operator = CmbPay.operator if operator.nil?
      operator_password = CmbPay.operator_password if operator_password.nil?
      "<BranchNo>#{branch_id}</BranchNo><MerchantNo>#{co_no}</MerchantNo><Operator>#{operator}</Operator><Password>#{operator_password}</Password><TimeStamp>#{Util.cmb_timestamp(t: time_stamp)}</TimeStamp><Command>#{cmb_command}</Command>"
    else
      "<BranchNo>#{branch_id}</BranchNo><MerchantNo>#{co_no}</MerchantNo><TimeStamp>#{Util.cmb_timestamp(t: time_stamp)}</TimeStamp><Command>#{cmb_command}</Command>"
    end
  end

  def self.build_direct_request_x_query_body(begin_date, end_date, count, operator, pos)
    operator = '9999' if operator.nil?
    begin_date = begin_date.strftime('%Y%m%d') unless begin_date.is_a?(String)
    end_date = end_date.strftime('%Y%m%d') unless end_date.is_a?(String)
    "<BeginDate>#{begin_date}</BeginDate><EndDate>#{end_date}</EndDate><Count>#{count}</Count><Operator>#{operator}</Operator><pos>#{pos}</pos>"
  end

  def self.hash_and_direct_request_x(co_key, head_inner_xml, body_inner_xml)
    co_key = CmbPay.co_key if co_key.nil?
    hash_input = "#{co_key}#{head_inner_xml}#{body_inner_xml}"
    hash_xml = "<Hash>#{Sign.sha1_digest(hash_input)}</Hash>"
    request_xml = "<Request><Head>#{head_inner_xml}</Head><Body>#{body_inner_xml}</Body>#{hash_xml}</Request>"
    HTTP.post(Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml })
  end

  def self.generate_pay_link_of(pay_type, payer_id, bill_no, amount_in_cents, merchant_url, merchant_para,
                                protocol, merchant_ret_url, merchant_ret_para, card_bank, options)
    branch_id = options.delete(:branch_id) || CmbPay.branch_id
    co_no = options.delete(:co_no) || CmbPay.co_no
    co_key = options.delete(:co_key) || CmbPay.co_key
    cmb_bill_no = Util.cmb_bill_no(bill_no)
    expire_in_minutes = options.delete(:expire_in_minutes) || CmbPay.expire_in_minutes
    pay_in_yuan, pay_in_cent = amount_in_cents.to_i.divmod(100)
    pay_amount = "#{pay_in_yuan}.#{format('%02d', pay_in_cent)}"
    cmb_merchant_para = Service.encode_merchant_para(merchant_para)
    trade_date = options.delete(:trade_date) || Time.now.strftime('%Y%m%d')
    payee_id = options.delete(:payee_id) || CmbPay.default_payee_id
    random = options.delete(:random)
    if protocol.is_a?(Hash) && !payer_id.nil?
      cmb_reserved_xml = "<Protocol><PNo>#{protocol['PNo']}</PNo><TS>#{protocol['TS'] || Time.now.strftime('%Y%m%d%H%M%S')}</TS><MchNo>#{CmbPay.mch_no}</MchNo><Seq>#{protocol['Seq']}</Seq><MUID>#{payer_id}</MUID><URL>#{merchant_url}</URL><Para>#{cmb_merchant_para}</Para></Protocol>"
    else
      cmb_reserved_xml = generate_cmb_card_bank_xml(card_bank)
      payee_id = nil
    end
    m_code = MerchantCode.generate(random: random, strkey: co_key, date: trade_date,
                                   branch_id: branch_id, co_no: co_no,
                                   bill_no: cmb_bill_no, amount: pay_amount,
                                   merchant_para: cmb_merchant_para, merchant_url: merchant_url,
                                   payer_id: payer_id, payee_id: payee_id,
                                   reserved: cmb_reserved_xml)
    uri_params = {
      'BranchID' => branch_id,
      'CoNo'     => co_no,
      'BillNo'   => cmb_bill_no,
      'Amount'   => pay_amount,
      'Date'     => trade_date,
      'ExpireTimeSpan' => expire_in_minutes,
      'MerchantUrl' => merchant_url,
      'MerchantPara' => cmb_merchant_para,
      'MerchantCode' => m_code
    }
    uri_params['MerchantRetUrl'] = merchant_ret_url unless merchant_ret_url.nil?
    uri_params['MerchantRetPara'] = merchant_ret_para unless merchant_ret_para.nil?
    Service.request_uri(pay_type, uri_params)
  end

  def self.generate_cmb_card_bank_xml(card_bank)
    return "<CardBank>#{format('%04d', card_bank.to_i)}</CardBank>" if /^\d+$/ =~ card_bank.to_s
    return nil if SUPPORTED_BANK[card_bank].nil?
    "<CardBank>#{format('%04d', SUPPORTED_BANK[card_bank])}</CardBank>"
  end
end
