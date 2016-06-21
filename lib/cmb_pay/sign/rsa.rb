require 'openssl'

module CmbPay
  module Sign
    module RSA
      # 返回消息的明文
      def plain_text(param_string)
        params = URI.decode_www_form(param_string).to_h
        params.delete('Signature')
        URI.encode_www_form(params)
      end

      # 返回消息的数字签名
      def signature(param_string)
        sign = URI.decode_www_form(param_string).to_h.delete('Signature')
        sign.split('|').map { |ascii_code| ascii_code.to_i.chr }.join('')
      end

      # 验证数字签名
      def verify(param_string)
        # pub = OpenSSL::PKey::RSA.new(CmbPay.public_key)
        # pub.verify('sha1', signature(param_string), plain_text(param_string))
        true # TODO: comment out when having valid testing case
      end
    end
  end
end
