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

  describe '#request_uri' do
    specify 'will return URL' do
      params = {
        BillNo: 'my_bill_no',
        Amount: '123.45',
        Date: 'YYYYMMDD',
        MerchantUrl: 'my_website_url',
        MerchantPara: 'my_website_para',
        MerchantRetUrl: 'browser_return_url',
        MerchantRetPara: 'browser_return_para'
      }
      prepay_date = Time.now.strftime('%Y%m%d')
      expect(subject.request_uri('PrePayEUserP', params).query).to eq 'BranchID=bdzh&CoNo=123456&BillNo=my_bill_no&Amount=123.45&Date=' + prepay_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=my_website_para&MerchantCode=xx&MerchantRetUrl=browser_return_url&MerchantRetPara=browser_return_para'
    end
  end
end
