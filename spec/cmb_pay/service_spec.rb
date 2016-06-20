require 'spec_helper'

describe CmbPay::Service do
  subject do
    CmbPay.branch_id = 'bdzh'
    CmbPay.co_no = '123456'
    CmbPay::Service
  end

  describe '#request_gateway_url' do
    specify 'will get GATEWAY_URL' do
      expect(subject.request_gateway_url('PrePayEUserP')).to eq 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayEUserP'
    end
  end
end
