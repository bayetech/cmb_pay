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

  describe '#encode_merchant_para' do
    specify 'will get encoded merchant para' do
      para_hash = { ReferenceNo: 12_345_678,
                    Branch: '上海',
                    SessionID: '20010901' }
      expect(subject.encode_merchant_para(para_hash)).to eq 'ReferenceNo=12345678|Branch=上海|SessionID=20010901'
    end

    specify 'will got empty string if input nil' do
      expect(subject.encode_merchant_para(nil)).to eq ''
    end
  end
end
