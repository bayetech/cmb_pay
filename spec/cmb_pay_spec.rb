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
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ioPQBO8m1cyanuKW%2FybtMowMjHHrjH78JTVBPrI1Yzhlk%2FFC8ZW3XQrO6zkUcJcVE77ky6%2FUtc7YRsKJzo1SKCMv*CJj3gAUPXSdLp0HKW8jU32DGVpfVD27Birp4jpkD6foWPiu4HKNHr5lWr3KaLLfiDlI2FrnMXX5DDdoI%2FtmTsiIpP7aWSifFOIOqLk*kJxBlFlCwNc6OW*5wnPZpwOq%2FtO0uR5OEVi3YyOSC4Q03QgE8aD15wkt5tYd0%3D%7C1d2b387aba971b0fa73bf3e39837a286e339b3f9&MerchantRetUrl=browser_return_url'
      expect(uri.to_s).to eq expect_result
    end
  end

  describe '#uri_of_pre_pay_c2' do
    specify 'will return PrePayC2 China Merchants Bank URI' do
      trade_date = Time.parse('July 7 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_c2(bill_no: 000000, amount_in_cents: 1,
                                      merchant_url: 'my_website_url',
                                      merchant_ret_url: 'browser_return_url',
                                      options: { random: '3.14', trade_date: trade_date })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?TestPrePayC2?BranchID=0755&CoNo=000257&BillNo=0000000000&Amount=0.01&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ilJWdg%2FVx%2F1azzKX7lOMk%3D%7Cac5c86147aba47fd5fd9a5974adfda66529d7dd8&MerchantRetUrl=browser_return_url'
      expect(uri.to_s).to eq expect_result
    end

    specify 'will return PrePayC2 Shanghai Bank URI' do
      trade_date = Time.parse('July 7 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_c2(bill_no: 000000, amount_in_cents: 1,
                                      merchant_url: 'my_website_url',
                                      merchant_ret_url: 'browser_return_url', card_bank: '上海银行',
                                      options: { random: '3.14', trade_date: trade_date })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?TestPrePayC2?BranchID=0755&CoNo=000257&BillNo=0000000000&Amount=0.01&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ilJWdg%2FVx%2F1azzKX7lOMkq1aaGP7jG%2FNVBFUnzXgsRkHQqFSdIB3jdz5zz7BdHOkMU7xm4lTdGjdEue96pgHKXNQ%3D%3D%7C4a50c9d582345d50f9e7b449846014a17f5e79d2&MerchantRetUrl=browser_return_url'
      expect(uri.to_s).to eq expect_result
    end
  end

  describe '#uri_of_pre_pay_wap' do
    specify 'will return PrePayWAP China Merchants Bank URI' do
      trade_date = Time.parse('July 11 2016').strftime('%Y%m%d')
      uri = subject.uri_of_pre_pay_wap(bill_no: 000000, amount_in_cents: 1,
                                       merchant_url: 'my_website_url',
                                       options: { random: '3.14', trade_date: trade_date })
      expect_result = 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?TestPrePayWAP?BranchID=0755&CoNo=000257&BillNo=0000000000&Amount=0.01&Date=' \
        + trade_date + '&ExpireTimeSpan=30&MerchantUrl=my_website_url&MerchantPara=&MerchantCode=%7CVkLiT8ilJWdg%2FVx%2F1azzKX7lOMk%3D%7C25499edb45eec01bf715cd877523652c01578c6c'
      expect(uri.to_s).to eq expect_result
    end
  end

  describe '#cmb_pay_message' do
    specify 'real CMB result with 2 value of merchant_para' do
      query_params = 'Succeed=Y&CoNo=000056&BillNo=000000&Amount=406.00&Date=20160710&MerchantPara=bill_no=fe5a64de823472dca4186a28759dd264|card_id=0104&Msg=07550000562016071000000000000000000000&Signature=163|81|102|123|242|141|88|91|206|112|113|27|202|119|101|133|231|160|194|14|60|221|40|81|233|0|150|225|72|150|248|74|248|184|183|118|130|213|18|232|100|123|173|74|60|248|142|143|184|14|236|43|248|235|95|38|93|182|253|113|236|212|159|255|'
      message = subject.cmb_pay_message(query_params)
      expect(message.valid?).to be_truthy
      expect(message.succeed?).to be_truthy
      expect(message.co_no).to eq '000056'
      expect(message.amount_cents).to eq 40600
      expect(message.order_date).to eq Date.new(2016, 7, 10)
      expect(message.payment_date).to eq Date.new(2016, 7, 10)
      expect(message.merchant_params['bill_no']).to eq 'fe5a64de823472dca4186a28759dd264'
      expect(message.merchant_params['card_id']).to eq '0104'
    end

    specify 'from a real CMB result should be valid' do
      query_params = 'Succeed=Y&CoNo=000056&BillNo=000000&Amount=0.01&Date=20160707&MerchantPara=&Msg=07550000562016070700000000000000000000&Signature=175|62|163|178|94|30|65|91|222|64|134|15|155|69|149|114|249|195|126|75|149|129|211|228|155|99|47|217|209|211|107|55|2|221|162|99|83|104|99|227|169|18|49|57|142|120|202|141|57|225|147|69|203|248|180|26|75|229|235|106|5|147|113|247|'
      message = subject.cmb_pay_message(query_params)
      expect(message.succeed?).to be_truthy
      expect(message.valid?).to be_truthy
      expect(message.discount?).to be_falsey
      expect(message.amount_cents).to eq 1
      expect(message.discount_amount_cents).to eq 0
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

  describe '#refund_no_dup' do
    specify 'will post refund_no_dup 5457, but not success' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><Operator>9999</Operator><Password>000257</Password><TimeStamp>523735825625</TimeStamp><Command>Refund_No_Dup</Command></Head><Body><Date>20160805</Date><BillNo>0000005457</BillNo><RefundNo>0000000097</RefundNo><Amount>149.99</Amount><Desc>test</Desc></Body><Hash>7072816a910c151ae8737e55ae0b532d0a1cb3a7</Hash></Request>'
      expect_result_xml = '<Response><Head><Code>NP2009</Code><ErrMsg>NP2009.无效请求：当前商户不允许进行直连退款</ErrMsg></Head><Body></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.refund_no_dup(bill_no: 5457, refund_no: 97, refund_amount_in_cents: 14999, memo: 'test',
                                             bill_date: '20160805', operator_password: '000257', time_stamp: 523735825625)
      expect(request_result).to eq expect_result_xml
    end
  end

  describe '#query_single_order' do
    specify 'will post query_single_order 5456' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523726352486</TimeStamp><Command>QuerySingleOrder</Command></Head><Body><Date>20160805</Date><BillNo>0000005456</BillNo></Body><Hash>348b863965127717e2822fd544bb6738773742a2</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><BillNo>0000005456</BillNo><Amount>6.88</Amount><AcceptDate>20160805</AcceptDate><AcceptTime>145354</AcceptTime><BillAmount>6.88</BillAmount><Status>0</Status><CardType>03</CardType><Fee>0.04</Fee><MerchantPara>bill_no%3d598331a5097eb572d7bd4ac96a1a6492</MerchantPara><CardNo>622575******6460</CardNo><BankSeqNo>16280531200000000020</BankSeqNo></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_single_order(bill_no: 5456, trade_date: '20160805', time_stamp: 523726352486)
      expect(request_result).to eq expect_result_xml
    end
    # bill_no 5457 exceed 100, so bill amount 159.99, and actual amount 149.99
    specify 'will post query_single_order 5457' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523726834219</TimeStamp><Command>QuerySingleOrder</Command></Head><Body><Date>20160805</Date><BillNo>0000005457</BillNo></Body><Hash>4d951e34be8c10e9b2a29ee31cbd3a362cb46f81</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><BillNo>0000005457</BillNo><Amount>149.99</Amount><AcceptDate>20160805</AcceptDate><AcceptTime>145441</AcceptTime><BillAmount>159.99</BillAmount><Status>0</Status><CardType>03</CardType><Fee>0.90</Fee><MerchantPara>bill_no%3de943df978e8213715d21b5a12669e0d5</MerchantPara><CardNo>622575******6460</CardNo><BankSeqNo>16280567000000000030</BankSeqNo></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_single_order(bill_no: 5457, trade_date: '20160805', time_stamp: 523726834219)
      expect(request_result).to eq expect_result_xml
    end
  end

  describe '#query_transact' do
    specify 'will post query_transact as direct request X' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523727813775</TimeStamp><Command>QueryTransact</Command></Head><Body><BeginDate>20150919</BeginDate><EndDate>20150923</EndDate><Count>2</Count><Operator>9999</Operator><pos></pos></Body><Hash>7d60537819b0e6db1223b422416eb7ed9d5d725f</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>2015091910475716272267400000000010</QryLopBlk><BllRecord><BillNo>0000003305</BillNo><MchDate>20160722</MchDate><StlDate>20150919</StlDate><BillState>0</BillState><BillAmount>0.98</BillAmount><FeeAmount>0.01</FeeAmount><CardType>07</CardType><BillRfn>16272205800000000010</BillRfn><BillType></BillType><StlAmount>0.98</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000003306</BillNo><MchDate>20160722</MchDate><StlDate>20150919</StlDate><BillState>0</BillState><BillAmount>4.18</BillAmount><FeeAmount>0.03</FeeAmount><CardType>07</CardType><BillRfn>16272267400000000010</BillRfn><BillType></BillType><StlAmount>4.18</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_transact(begin_date: '20150919', end_date: '20150923', count: 2,
                                              time_stamp: 523727813775)
      expect(request_result).to eq expect_result_xml
    end

    specify 'will post query_transact as direct request X with pos' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523730558849</TimeStamp><Command>QueryTransact</Command></Head><Body><BeginDate>20150919</BeginDate><EndDate>20150923</EndDate><Count>2</Count><Operator>9999</Operator><pos>2015091910475716272267400000000010</pos></Body><Hash>aff9f9c46455c2165c64b8380df079a398ca26c9</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>2015091910524216272262700000000010</QryLopBlk><BllRecord><BillNo>0000003309</BillNo><MchDate>20160722</MchDate><StlDate>20150919</StlDate><BillState>0</BillState><BillAmount>6.88</BillAmount><FeeAmount>0.04</FeeAmount><CardType>07</CardType><BillRfn>16272225300000000010</BillRfn><BillType></BillType><StlAmount>6.88</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000003310</BillNo><MchDate>20160722</MchDate><StlDate>20150919</StlDate><BillState>0</BillState><BillAmount>6.88</BillAmount><FeeAmount>0.04</FeeAmount><CardType>07</CardType><BillRfn>16272262700000000010</BillRfn><BillType></BillType><StlAmount>6.88</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_transact(begin_date: '20150919', end_date: '20150923', count: 2, pos: '2015091910475716272267400000000010',
                                              time_stamp: 523730558849)
      expect(request_result).to eq expect_result_xml
    end

    specify 'will post query_transact as direct request X as different account' do
      request_xml = '<Request><Head><BranchNo>0731</BranchNo><MerchantNo>000005</MerchantNo><TimeStamp>523042695395</TimeStamp><Command>QueryTransact</Command></Head><Body><BeginDate>20160726</BeginDate><EndDate>20160727</EndDate><Count>10</Count><Operator>9999</Operator><pos></pos></Body><Hash>5921609f50ff447c5f610fdf4607cb5416fe97ed</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>N</QryLopFlg><QryLopBlk>00000000000000                    </QryLopBlk></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_transact(begin_date: '20160726', end_date: '20160727', count: 10,
                                              branch_id: '0731', co_no: '000005', time_stamp: 523042695395)
      expect(request_result).to eq expect_result_xml
    end
  end

  describe '#query_settled_order_by_merchant_date' do
    specify 'will post query_settled_order_by_merchant_date as direct request X' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523731435008</TimeStamp><Command>QuerySettledOrderByMerchantDate</Command></Head><Body><BeginDate>20160805</BeginDate><EndDate>20160805</EndDate><Count>2</Count><Operator>9999</Operator><pos></pos></Body><Hash>3f33ffbbe9a54a9b86a0b18cd7226a51dc11f4f5</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>HH00012016080515443416280566200000000020</QryLopBlk><BllRecord><BillNo>0000005477</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>0</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280573200000000010</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000005474</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>0</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280566200000000020</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_settled_order_by_merchant_date(begin_date: '20160805', end_date: '20160805', count: 2,
                                                                    time_stamp: 523731435008)
      expect(request_result).to eq expect_result_xml
    end

    specify 'will post query_settled_order_by_merchant_date with pos' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523731718930</TimeStamp><Command>QuerySettledOrderByMerchantDate</Command></Head><Body><BeginDate>20160805</BeginDate><EndDate>20160805</EndDate><Count>3</Count><Operator>9999</Operator><pos>HH00012016080515443416280566200000000020</pos></Body><Hash>956b8f831c0490fdc7d35038a9b2ebc3ce450cda</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>HH00012016080515301916280567000000000040</QryLopBlk><BllRecord><BillNo>0000005472</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>0</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280525100000000010</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000005471</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>0</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280566100000000020</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000005469</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>0</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280567000000000040</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_settled_order_by_merchant_date(begin_date: '20160805', end_date: '20160805', count: 3, pos: 'HH00012016080515443416280566200000000020',
                                                                    time_stamp: 523731718930)
      expect(request_result).to eq expect_result_xml
    end
  end

  describe '#query_settled_order_by_settled_date' do
    specify 'will post query_settled_order_by_settled_date as direct request X' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523732011805</TimeStamp><Command>QuerySettledOrderBySettledDate</Command></Head><Body><BeginDate>20160805</BeginDate><EndDate>20160805</EndDate><Count>1</Count><Operator>9999</Operator><pos></pos></Body><Hash>779a26d9beea763db5f4a7c783a329cc1f087caa</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>HH00012016080515533016280573200000000010</QryLopBlk><BllRecord><BillNo>0000005477</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>6</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280573200000000010</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_settled_order_by_settled_date(begin_date: '20160805', end_date: '20160805', count: 1,
                                                                   time_stamp: 523732011805)
      expect(request_result).to eq expect_result_xml
    end

    specify 'will post query_settled_order_by_settled_date with pos' do
      request_xml = '<Request><Head><BranchNo>0755</BranchNo><MerchantNo>000257</MerchantNo><TimeStamp>523732240132</TimeStamp><Command>QuerySettledOrderBySettledDate</Command></Head><Body><BeginDate>20160805</BeginDate><EndDate>20160805</EndDate><Count>2</Count><Operator>9999</Operator><pos>HH00012016080515533016280573200000000010</pos></Body><Hash>845e207806d9d8b76e9767d7b3b70e3998368e56</Hash></Request>'
      expect_result_xml = '<Response><Head><Code></Code><ErrMsg></ErrMsg></Head><Body><QryLopFlg>Y</QryLopFlg><QryLopBlk>HH00012016080515415316280525100000000010</QryLopBlk><BllRecord><BillNo>0000005474</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>6</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280566200000000020</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord><BllRecord><BillNo>0000005472</BillNo><MchDate>20160805</MchDate><StlDate>20160805</StlDate><BillState>6</BillState><BillAmount>0.03</BillAmount><FeeAmount>0.00</FeeAmount><CardType>03</CardType><BillRfn>16280525100000000010</BillRfn><BillType></BillType><StlAmount>0.03</StlAmount><DecPayAmount>0.00</DecPayAmount></BllRecord></Body></Response>'
      expect(HTTP).to receive(:post).with(CmbPay::Service.request_gateway_url(:DirectRequestX), form: { 'Request' => request_xml }).and_return(expect_result_xml)
      request_result = subject.query_settled_order_by_settled_date(begin_date: '20160805', end_date: '20160805', count: 2, pos: 'HH00012016080515533016280573200000000010',
                                                                   time_stamp: 523732240132)
      expect(request_result).to eq expect_result_xml
    end
  end
end
