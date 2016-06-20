require 'cmb_pay/version'
require 'cmb_pay/service'

module CmbPay
  class << self
    attr_accessor :branch_id # 开户分行号
    attr_accessor :co_no     # 支付商户号/收单商户号
    attr_accessor :environment
  end
  @environment = :production
end
