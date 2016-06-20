require 'spec_helper'

describe CmbPay do
  subject do
    CmbPay.branch_id = 'bdzh'
    CmbPay.co_no = '123456'
    CmbPay
  end

  describe '#generate_PrePayEUserP_link' do
    specify 'will return PrePayEUserP URL' do
      params = {
        BillNo: 'my_bill_no',
        Amount: '123.45',
        MerchantUrl: 'my_website_url',
        MerchantPara: 'my_website_para',
        MerchantRetUrl: 'browser_return_url',
        MerchantRetPara: 'browser_return_para'
      }
      prepay_date = Time.now.strftime('%Y%m%d')
      expect(subject.generate_PrePayEUserP_link(params).query).to eq 'BranchID=bdzh&CoNo=123456&BillNo=my_bill_no&Amount=123.45&Date=' + prepay_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=my_website_para&MerchantCode=xx&MerchantRetUrl=browser_return_url&MerchantRetPara=browser_return_para'
    end
  end
end
