module CmbPay
  module Sign
    module SHA1
      def self.digest(str)
        OpenSSL::Digest::SHA1.hexdigest(str)
      end
    end
  end
end
