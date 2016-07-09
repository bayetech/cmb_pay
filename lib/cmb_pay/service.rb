module CmbPay
  module Service
    GATEWAY_URL = {
      production: {
        NP_BindCard:  'https://mobile.cmbchina.com/mobilehtml/DebitCard/M_NetPay/OneNetRegister/NP_BindCard.aspx',
        PrePayEUserP: 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayEUserP',
        PrePayC2: 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayC2'
      },
      test: {
        NP_BindCard:  'http://61.144.248.29:801/mobilehtml/DebitCard/M_NetPay/OneNetRegister/NP_BindCard.aspx',
        PrePayEUserP: 'http://61.144.248.29:801/netpayment/BaseHttp.dll?PrePayEUserP',
        PrePayC2: 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?TestPrePayC2'
      }
    }.freeze

    def self.request_gateway_url(api_action)
      GATEWAY_URL[CmbPay.environment.to_sym][api_action.to_sym]
    end

    def self.request_uri(api_action, params)
      uri = URI(request_gateway_url(api_action))
      uri.query = if CmbPay.environment.to_sym == :test && api_action.to_sym == :PrePayC2
                    "TestPrePayC2?#{URI.encode_www_form(params)}"
                  else
                    "#{uri.query}?#{URI.encode_www_form(params)}"
                  end
      uri
    end

    def self.encode_merchant_para(para)
      if para.nil?
        ''
      else
        para.to_a.collect { |c| "#{c[0]}=#{c[1]}" }.join '|'
      end
    end
  end
end
