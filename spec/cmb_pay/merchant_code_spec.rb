require 'spec_helper'

describe CmbPay::MerchantCode do
  subject do
    CmbPay::MerchantCode
  end

  describe '#generate' do
    specify 'test case from CMB document' do
      expect(subject.generate(strkey: 'KeyString', date: '20081129', branch_id: '0755', co_no: '000354', bill_no: '0011223344',
                              amount: '12.43', merchant_para: 'MerchantParaValue', merchant_url: 'http://www.abc.com/bankReciev',
                              payer_id: 'User1', payee_id: 'User2', client_ip: '202.97.113.23', goods_type: '00000000'))
        .to eq '|aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==|acdc1b7113a47324c2209626d11fa632e1210b1c'
    end
  end

  describe '#md5_hash' do
    specify 'test case from CMB document' do
      expect(subject.md5_hash('KeyString')).to eq 'D04B908FFAF0D3213EE9B724E8B4FED8'
    end
  end
end
