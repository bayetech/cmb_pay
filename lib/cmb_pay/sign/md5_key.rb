require 'digest/md5'

module CmbPay
  module Sign
    module MD5key
      def self.digest(str_key)
        Digest::MD5.hexdigest(str_key.encode('gb2312')).upcase
      end
    end
  end
end
