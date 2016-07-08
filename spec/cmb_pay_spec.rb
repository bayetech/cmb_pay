require 'spec_helper'

describe CmbPay do
  subject do
    CmbPay.branch_id = '0755'
    CmbPay.co_no = '000257'
    CmbPay.co_key = ''
    CmbPay.mch_no = 'P0019844'
    CmbPay.default_payee_id = '1'
    CmbPay.environment = 'test'
    CmbPay
  end

  describe '#uri_of_pre_pay_euserp' do
    specify 'will return PrePayEUserP URI' do
      trade_date = Time.parse('July 6 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_euserp(payer_id: 1, bill_no: 654321, amount_in_cents: '12345',
                                          merchant_url: 'my_website_url',
                                          merchant_ret_url: 'browser_return_url',
                                          protocol: { 'PNo' => 1,
                                                      'Seq' => 12345,
                                                      'TS' => '20160704190627' },
                                          options: { random: '3.14', trade_date: trade_date })
      expect_result = 'http://61.144.248.29:801/netpayment/BaseHttp.dll?PrePayEUserP?BranchID=0755&CoNo=000257&BillNo=0000654321&Amount=123.45&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ioPQBO8m1cyanuKW%2FybtMowMjHHrjH78JTVBPrI1Yzhlk%2FFC8ZW3XQrO6zkUcJcVE77ky6%2FUtc7YRsKJzo1SKCMv*CJj3gAUPXSdLp0HKW8jU32DGVpfVD27Birp4jpkD6foWPiu4HKNHr5lWr3KaLLfiDlI2FrnMXX5DDdoI%2FtmTsiIpP7aWSifFOIOqLk*kJxBlFlCwNc6OW*5wnPZpwOq%2FtO0uR5OEVi3YyOSC4Q03QgE8aD15wkt5tYd0%3D%7C1d2b387aba971b0fa73bf3e39837a286e339b3f9&MerchantRetUrl=browser_return_url&MerchantRetPara'
      expect(uri.to_s).to eq expect_result
    end
  end

  describe '#uri_of_pre_pay_c2' do
    specify 'will return PrePayC2 URI' do
      trade_date = Time.parse('July 7 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_c2(bill_no: 000000, amount_in_cents: 1,
                                      merchant_url: 'my_website_url',
                                      merchant_ret_url: 'browser_return_url',
                                      options: { random: '3.14', trade_date: trade_date })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?TestPrePayC2?BranchID=0755&CoNo=000257&BillNo=0000000000&Amount=0.01&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ilJWdg%2FVx%2F1azzKX7lOMk%3D%7Cac5c86147aba47fd5fd9a5974adfda66529d7dd8&MerchantRetUrl=browser_return_url&MerchantRetPara'
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

    specify 'from a real CMB result should be valid too' do
      query_params = 'Succeed=Y&CoNo=000056&BillNo=000000&Amount=0.01&Date=20160708&MerchantPara=bill_no=3025&Msg=07550000562016070800000000000000000000&Signature=91|8|221|250|17|39|84|234|249|242|86|252|57|81|240|57|232|233|131|152|182|180|253|171|92|49|28|24|237|95|239|118|53|137|96|130|196|128|191|79|131|137|114|43|241|7|204|15|48|138|189|64|255|21|162|157|208|3|70|247|205|118|72|138|'
      message = subject.cmb_pay_message(query_params)
      expect(message.succeed?).to be_truthy
      expect(message.valid?).to be_truthy
      expect(message.amount_cents).to eq 1
      expect(message.branch_id).to eq '0755'
      expect(message.co_no).to eq '000056'
      expect(message.date).to eq '20160708'
      expect(message.merchant_para).to eq 'bill_no=3025'
      expect(message.merchant_params['bill_no']).to eq '3025'
    end
  end
end
