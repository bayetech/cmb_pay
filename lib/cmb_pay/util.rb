module CmbPay
  module Util
    MILLISECONDS_SINCE_UNIX_EPOCH = Time.new(2000, 1, 1).to_i * 1000

    def self.hex_to_binary(str)
      [str].pack('H*')
    end

    def self.binary_to_hex(s)
      s.unpack('H*')[0].upcase
    end

    def self.cmb_timestamp(t: nil)
      return t if t.is_a?(Integer)
      t = Time.now if t.nil?
      t.to_i * 1000 + (t.usec / 1000) - MILLISECONDS_SINCE_UNIX_EPOCH
    end

    # 招行定单号，6位或10位长数字，由商户系统生成，一天内不能重复
    def self.cmb_bill_no(bill_no)
      format('%010d', bill_no.to_i % 10_000_000_000)
    end
  end
end
