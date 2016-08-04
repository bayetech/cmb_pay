require 'spec_helper'

describe CmbPay::Util do
  subject do
    CmbPay::Util
  end

  describe '#cmb_timestamp' do
    specify 'will got milli seconds since Y2K' do
      expect(subject.cmb_timestamp(t: Time.new(2014, 6, 27, 9, 38, 15))).to eq 457_177_095_000
    end
  end
end
