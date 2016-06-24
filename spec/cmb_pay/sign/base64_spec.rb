require 'spec_helper'

describe CmbPay::Sign do
  subject do
    CmbPay::Sign
  end

  describe '#encode64' do
    specify 'test encode64 have replace * with +' do
      rc4_result = CmbPay::Util.hex_to_binary('686A43B0471B98EB98712793E6B4219E5D19D7C38A92E00996F0C95DA7B1DCA2570A7ECA27D5D87E2C3E521216EBF6BE6114C7D4898BC183CCC9B7AF3CB20E531D72E967449DFBFCE25A16F4917C9EFC371ECBFF2164292DDF3449AC2EC686CD69BE4E30EC692E')
      expect(subject.encode_base64(rc4_result))
        .to eq 'aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg=='
    end
  end
end
