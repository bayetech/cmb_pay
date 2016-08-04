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
      t = Time.now if t.nil?
      t.to_i * 1000 + (t.usec / 1000) - MILLISECONDS_SINCE_UNIX_EPOCH
    end
  end
end
