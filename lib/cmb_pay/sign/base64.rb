require 'base64'

module CmbPay
  module Sign
    # CMB replace '+' with '*' according to standard Base64
    module Base64
      def self.encode64(bin)
        ::Base64.strict_encode64(bin).tr('+', '*')
      end
    end
  end
end
