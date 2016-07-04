require 'spec_helper'

describe CmbPay::MerchantCode do
  subject do
    CmbPay::MerchantCode
  end

  describe '#generate' do
    specify 'test case from CMB document' do
      expect(subject.generate(random: '3.14', strkey: 'KeyString', date: '20081129', branch_id: '0755', co_no: '000354', bill_no: '0011223344',
                              amount: '12.43', merchant_para: 'MerchantParaValue', merchant_url: 'http://www.abc.com/bankReciev',
                              payer_id: 'User1', payee_id: 'User2', client_ips: '202.97.113.23', goods_type: '00000000'))
        .to eq '|aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==|acdc1b7113a47324c2209626d11fa632e1210b1c'
    end

    specify 'test case using my birthday' do
      expect(subject.generate(random: '6.27', strkey: 'KeyString', date: '20081129', branch_id: '0755', co_no: '000354', bill_no: '0011223344',
                              amount: '12.43', merchant_para: 'MerchantParaValue', merchant_url: 'http://www.abc.com/bankReciev',
                              payer_id: 'User1', payee_id: 'User2', client_ips: '202.97.113.23', goods_type: '00000000'))
        .to eq '|bWpAs0cbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==|346a0d50df3f92fd0c973a7842f23f8fc8d858a2'
    end

    specify 'first test case with CMB bank' do
      expect(subject.generate(random: '3.14', strkey: '', date: '20160704', branch_id: '0755', co_no: '000257', bill_no: '0000002883',
                              amount: '688.00', merchant_para: '', merchant_url: 'http://localhost:3000/mine/payments/ywt_callback',
                              payer_id: '901', payee_id: '1', client_ips: '', goods_type: '',
                              reserved: '<Protocol><PNo>901</PNo><Seq>2883</Seq><MchNo>P0019844</MchNo></Protocol>'))
        .to eq '|VkLiT8igMRUxu0xi25b3MXLjaJJk1crScPnm78NAQwGqeU5dyGY5FDgZVCSAwpyM4RkLZzFEvV3W53dc4*c4b5Lt3S6AN*DncXviElrnH6DLjUrorTpe0DWQoOI6jOQDjMN3x3*2LaKFmL9aJN7w9zvh/KaIZaGq5fo=|77629760e4b1c45051a39e1f151a18ed27f34f1b'
    end
  end
end
