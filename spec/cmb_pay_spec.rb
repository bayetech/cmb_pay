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
      trade_date = Time.parse('July 6 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_euserp(payer_id: 1, bill_no: 654321, amount_in_cents: '12345',
                                          merchant_url: 'my_website_url',
                                          merchant_para: 'my_website_para',
                                          merchant_ret_url: 'browser_return_url',
                                          merchant_ret_para: 'browser_return_para',
                                          protocol: { 'PNo' => 1,
                                                      'Seq' => 12345,
                                                      'TS' => '20160704190627' },
                                          options: { random: '3.14', trade_date: trade_date })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayEUserP?BranchID=0755&CoNo=000257&BillNo=0000654321&Amount=123.45&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=my_website_para&MerchantCode=%7CVkLiT8ioPQBO8m1cyanuKW%2FybtMowMjHHrjH78JTVBPrI1Yzhlk%2FFC8ZW3XQrO6zkUcJcVE77ky6%2FUtc7YRsKJzo1SKCMv*CJj3gAUPXSdLp0HKW8jU32DGVpfVD27Birp4jpkD6foWPiu4HKNHr5lWr3KaLLfiDlI2FrnMXX5DDdoI%2FtmTsiIpP7aWSifFOIOqLk*kJxBlFlCwNc6OW*5wnPcsmNbn6OAbEv9Q4lGMvO3P7LRCNxSNDU2twi89mJoyVjVIjLWINuos9gh1N*f4%3D%7Ca96c8836290c02466d84ecadef4f34f1cf2c0922&MerchantRetUrl=browser_return_url&MerchantRetPara=browser_return_para'
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

    specify 'from a real CMB result should be valid' do
      query_params = 'Succeed=Y&CoNo=000056&BillNo=000000&Amount=0.01&Date=20160707&MerchantPara=&Msg=07550000562016070700000000000000000000&Signature=175|62|163|178|94|30|65|91|222|64|134|15|155|69|149|114|249|195|126|75|149|129|211|228|155|99|47|217|209|211|107|55|2|221|162|99|83|104|99|227|169|18|49|57|142|120|202|141|57|225|147|69|203|248|180|26|75|229|235|106|5|147|113|247|'
      message = subject.cmb_pay_message(query_params)
      expect(message.succeed?).to be_truthy
      expect(message.valid?).to be_truthy
      expect(message.amount_cents).to eq 1
      expect(message.branch_id).to eq '0755'
      expect(message.co_no).to eq '000056'
    end
  end
end
