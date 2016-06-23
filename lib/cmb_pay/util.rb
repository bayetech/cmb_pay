module CmbPay
  module Util
    def self.hex_to_binary(str)
      str.scan(/../).map(&:hex).map(&:chr).join
    end

    def self.binary_to_hex(s)
      s.each_byte.map { |b| b.to_s(16).rjust(2, '0') }.join
    end
  end
end
