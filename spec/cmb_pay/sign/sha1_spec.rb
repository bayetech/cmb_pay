require 'spec_helper'

describe CmbPay::Sign do
  subject do
    CmbPay::Sign
  end

  describe '#digest' do
    specify 'SHA1 will digest the right hashed value' do
      input = 'KeyStringaGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==200811290755000354001122334412.43MerchantParaValuehttp://www.abc.com/bankReciev'
      expect(subject.sha1_digest(input)).to eq 'acdc1b7113a47324c2209626d11fa632e1210b1c'
    end
  end
end
