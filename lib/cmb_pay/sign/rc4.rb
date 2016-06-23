module CmbPay
  module Sign
    module RC4
      def self.encrypt(md5_hash, data)
        cipher = OpenSSL::Cipher.new('RC4')
        cipher.encrypt
        cipher.key = Util.hex_to_binary(md5_hash)
        cipher.update(data.encode('gb2312')) + cipher.final
      end
    end
  end
end
