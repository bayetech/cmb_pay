require 'spec_helper'

describe CmbPay do
  subject do
    CmbPay.branch_id = '0755'
    CmbPay.co_no = '000257'
    CmbPay.co_key = ''
    CmbPay.mch_no = 'P0019844'
    CmbPay.default_payee_id = '1'
    CmbPay
  end

  describe '#uri_of_pre_pay_euserp' do
    specify 'will return PrePayEUserP URI' do
      trade_date = Time.now.strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_euserp(payer_id: 1, bill_no: 654321, amount_in_cents: '12345',
                                          merchant_url: 'my_website_url',
                                          merchant_para: 'my_website_para',
                                          merchant_ret_url: 'browser_return_url',
                                          merchant_ret_para: 'browser_return_para',
                                          protocol: { 'PNo' => 1,
                                                      'Seq' => 12345,
                                                      'TS' => '20160704190627' },
                                          options: { random: '3.14' })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayEUserP?BranchID=0755&CoNo=000257&BillNo=0000654321&Amount=123.45&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=my_website_para&MerchantCode=%7CVkLiT8ioPQBO8m1cyanuKW%2FybtMowMjHHrjH78JTVBPrI1Yzhlk%2FFC8ZW3XQrO6zkUcJcVE77ky6%2FUtc7YRsKJzo1SKCMv*CJj3gAUPXSdLp0HKW8jU32DGVpfVD27Birp4jpkD6foWPiu4HKNHr5lWr3KaLLfjhkbau5C1IH7GoA*kl2FTNocZU8Z7B0g%3D%3D%7C26d4a8ecd0bb78db969465f71e9c518beedff5e3&MerchantRetUrl=browser_return_url&MerchantRetPara=browser_return_para'
      expect(uri.to_s).to eq expect_result
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
