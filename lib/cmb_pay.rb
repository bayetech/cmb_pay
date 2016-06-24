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
    attr_accessor :environment
  end
  @environment = :production

  def self.uri_of_PrePayEUserP(params, options = {})
    branch_id = options.delete(:branch_id)
    co_no = options.delete(:co_no)
    uri_params = {
      'BranchID' => branch_id || CmbPay.branch_id,
      'CoNo'     => co_no || CmbPay.co_no,
      'BillNo'   => params[:BillNo],
      'Amount'   => params[:Amount],
      'Date'     => Time.now.strftime('%Y%m%d'),
      'ExpireTimeSpan' => params[:ExpireTimeSpan] || 30,
      'MerchantUrl' => params[:MerchantUrl],
      'MerchantPara' => params[:MerchantPara],
      'MerchantCode' => 'xx', # TODO: Need implement
      'MerchantRetUrl' => params[:MerchantRetUrl],
      'MerchantRetPara' => params[:MerchantRetPara]
    }
    Service.request_uri('PrePayEUserP', uri_params)
  end

  def self.cmb_pay_message(query_string)
    CmbPay::Message.new query_string
  end
end
