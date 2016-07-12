module CmbPay
  module Util
    def self.hex_to_binary(str)
      [str].pack('H*')
    end

    def self.binary_to_hex(s)
      s.unpack('H*')[0].upcase
    end
  end
end
