require 'date'
require 'uri'
require 'cmb_pay/version'
require 'cmb_pay/util'
require 'cmb_pay/sign'
require 'cmb_pay/merchant_code'
require 'cmb_pay/message'
require 'cmb_pay/service'

module CmbPay
  class << self
    attr_accessor :branch_id # 开户分行号
    attr_accessor :co_no     # 支付商户号/收单商户号
    attr_accessor :expire_in_minutes # 会话有效时间
    attr_accessor :environment
  end
  @environment = :production

  def self.uri_of_pre_pay_euserp(bill_no:, amount:, merchant_url:, merchant_para:,
                                 merchant_ret_url: nil, merchant_ret_para: nil,
                                 options: {})
    branch_id = options.delete(:branch_id)
    co_no = options.delete(:co_no)
    expire_time_span = options.delete(:expire_time_span)
    uri_params = {
      'BranchID' => branch_id || CmbPay.branch_id,
      'CoNo'     => co_no || CmbPay.co_no,
      'BillNo'   => bill_no,
      'Amount'   => amount,
      'Date'     => Time.now.strftime('%Y%m%d'),
      'ExpireTimeSpan' => expire_time_span || CmbPay.expire_in_minutes || 30,
      'MerchantUrl' => merchant_url,
      'MerchantPara' => merchant_para,
      'MerchantCode' => 'xx', # TODO: Need implement
    }
    uri_params['MerchantRetUrl'] = merchant_ret_url unless merchant_ret_url.nil?
    uri_params['MerchantRetPara'] = merchant_ret_para unless merchant_ret_para.nil?
    Service.request_uri('PrePayEUserP', uri_params)
  end

  def self.cmb_pay_message(query_string)
    CmbPay::Message.new query_string
  end
end
