require 'spec_helper'

describe CmbPay::Util do
  subject do
    CmbPay::Util
  end

  describe '#cmb_timestamp' do
    specify 'will got milli seconds since Y2K' do
      expect(subject.cmb_timestamp(t: Time.new(2014, 6, 27, 9, 38, 15))).to eq 457_177_095_000
    end

    specify 'will got correct timestamp from CMB case' do
      expect(subject.cmb_timestamp(t: Time.new(2016, 7, 28, 17, 38, 15))).to eq 523_042_695_000
    end
  end
end
