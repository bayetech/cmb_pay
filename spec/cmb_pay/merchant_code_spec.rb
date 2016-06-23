require 'spec_helper'

describe CmbPay::MerchantCode do
  subject do
    CmbPay::MerchantCode
  end

  describe '#generate' do
    specify 'test case from CMB document' do
      expect(subject.generate(strkey: 'KeyString', date: '20081129', branch_id: '0755', co_no: '000354', bill_no: '0011223344',
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
  end
end
