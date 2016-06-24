require 'base64'
require 'digest/md5'
require 'openssl' # For RC4/RSA/SHA1

module CmbPay
  module Sign
    module Sha1WithRsa
      # 返回消息的明文
      def self.plain_text(param_string)
        params = URI.decode_www_form(param_string).to_h
        params.delete('Signature')
        URI.encode_www_form(params)
      end

      # 返回消息的数字签名
      def self.signature(param_string)
        sign = URI.decode_www_form(param_string).to_h.delete('Signature')
        sign.split('|').map { |ascii_code| ascii_code.to_i.chr }.join('')
      end

      # 验证数字签名
      def self.verify(param_string)
        pub = OpenSSL::PKey::RSA.new(CmbPay::Service::PUBLIC_KEY)
        pub.verify('sha1', signature(param_string), plain_text(param_string))
      end
    end

    # CMB replace '+' with '*' according to standard Base64
    def self.encode_base64(bin)
      ::Base64.strict_encode64(bin).tr('+', '*')
    end

    def self.md5_key_digest(str_key)
      Digest::MD5.hexdigest(str_key.encode('gb2312')).upcase
    end

    def self.rc4_encrypt(md5_hash, data)
      cipher = OpenSSL::Cipher.new('RC4')
      cipher.encrypt
      cipher.key = Util.hex_to_binary(md5_hash)
      cipher.update(data.encode('gb2312')) + cipher.final
    end

    def self.sha1_digest(str)
      OpenSSL::Digest::SHA1.hexdigest(str)
    end
  end
end
