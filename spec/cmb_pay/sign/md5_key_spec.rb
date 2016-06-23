require 'spec_helper'

describe CmbPay::Sign::MD5key do
  subject do
    CmbPay::Sign::MD5key
  end

  describe '#digest' do
    specify 'MD5 Key will got the right hashed value' do
      str_form_md5_hash = CmbPay::Util.hex_to_binary(subject.digest('KeyString'))
      expect(CmbPay::Util.binary_to_hex(str_form_md5_hash)).to eq 'D04B908FFAF0D3213EE9B724E8B4FED8'
    end
  end
end
