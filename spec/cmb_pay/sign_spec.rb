require 'spec_helper'

describe CmbPay::Sign do
  subject do
    CmbPay::Sign
  end

  describe '#encode_base64' do
    specify 'test encode64 have replace * with +' do
      rc4_result = CmbPay::Util.hex_to_binary('686A43B0471B98EB98712793E6B4219E5D19D7C38A92E00996F0C95DA7B1DCA2570A7ECA27D5D87E2C3E521216EBF6BE6114C7D4898BC183CCC9B7AF3CB20E531D72E967449DFBFCE25A16F4917C9EFC371ECBFF2164292DDF3449AC2EC686CD69BE4E30EC692E')
      expect(subject.encode_base64(rc4_result))
        .to eq 'aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg=='
    end
  end

  describe '#md5_key_digest' do
    specify 'MD5 Key will got the right hashed value' do
      str_form_md5_hash = CmbPay::Util.hex_to_binary(subject.md5_key_digest('KeyString'))
      expect(CmbPay::Util.binary_to_hex(str_form_md5_hash)).to eq 'D04B908FFAF0D3213EE9B724E8B4FED8'
    end
  end

  describe '#rc4_encrypt' do
    specify 'RC4 encrypt should same as cmbJava.jar result' do
      strkey_md5_digest = 'D04B908FFAF0D3213EE9B724E8B4FED8'
      input = '3.14|User1<$CmbSplitter$>User2<$ClientIP$>202.97.113.23</$ClientIP$><$GoodsType$>00000000</$GoodsType$>'
      encrypted = subject.rc4_encrypt(strkey_md5_digest, input)
      expect(CmbPay::Util.binary_to_hex(encrypted)).to eq '686A43B0471B98EB98712793E6B4219E5D19D7C38A92E00996F0C95DA7B1DCA2570A7ECA27D5D87E2C3E521216EBF6BE6114C7D4898BC183CCC9B7AF3CB20E531D72E967449DFBFCE25A16F4917C9EFC371ECBFF2164292DDF3449AC2EC686CD69BE4E30EC692E'
      expect(CmbPay::Sign.encode_base64(encrypted)).to eq 'aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg=='
    end
  end

  describe '#sha1_digest' do
    specify 'SHA1 will digest the right hashed value' do
      input = 'KeyStringaGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==200811290755000354001122334412.43MerchantParaValuehttp://www.abc.com/bankReciev'
      expect(subject.sha1_digest(input)).to eq 'acdc1b7113a47324c2209626d11fa632e1210b1c'
    end

    specify 'Another test from CMB bank' do
      input = 'abc'
      expect(subject.sha1_digest(input)).to eq 'a9993e364706816aba3e25717850c26c9cd0d89d'
    end
  end
end
