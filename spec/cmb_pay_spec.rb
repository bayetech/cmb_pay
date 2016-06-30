require 'spec_helper'

describe CmbPay do
  subject do
    CmbPay.branch_id = 'bdzh'
    CmbPay.co_no = '123456'
    CmbPay
  end

  describe '#uri_of_pre_pay_euserp' do
    specify 'will return PrePayEUserP URI' do
      prepay_date = Time.now.strftime('%Y%m%d')
      expect(subject.uri_of_pre_pay_euserp(bill_no: 'my_bill_no', amount_in_cents: '12345',
                                           merchant_url: 'my_website_url', merchant_para: 'my_website_para',
                                           merchant_ret_url: 'browser_return_url', merchant_ret_para: 'browser_return_para').query)
        .to eq 'BranchID=bdzh&CoNo=123456&BillNo=my_bill_no&Amount=123.45&Date=' + prepay_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=my_website_para&MerchantCode=xx&MerchantRetUrl=browser_return_url&MerchantRetPara=browser_return_para'
    end
  end

  describe '#cmb_pay_message' do
    specify 'will return a new CmbPay::Message' do
      query_params = 'Succeed=Y&CoNo=xxxxxx&BillNo=xxxxxx&Amount=123.45&Date=20160621&MerchantPara=xxxx&Msg=bdzh1234562016062209876543211234567890&Signature=xxxxxxx'
      message = subject.cmb_pay_message(query_params)
      expect(message.valid?).to be false # TODO: Need a real example
      expect(message.succeed?).to be_truthy
      expect(message.co_no).to eq 'xxxxxx'
      expect(message.amount_cents).to eq 12345
      expect(message.order_date).to eq Date.new(2016, 6, 21)
      expect(message.payment_date).to eq Date.new(2016, 6, 22)
      expect(message.bank_serial_no).to eq '09876543211234567890'
    end
  end
end
