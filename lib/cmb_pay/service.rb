module CmbPay
  module Service
    GATEWAY_URL = {
      production: {
        NP_BindCard:  'https://mobile.cmbchina.com/mobilehtml/DebitCard/M_NetPay/OneNetRegister/NP_BindCard.aspx',
        PrePayEUserP: 'https://netpay.cmbchina.com/netpayment/BaseHttp.dll?PrePayEUserP'
      },
      test: {
        NP_BindCard:  'http://61.144.248.29:801/mobilehtml/DebitCard/M_NetPay/OneNetRegister/NP_BindCard.aspx',
        PrePayEUserP: 'http://61.144.248.29:801/netpayment/BaseHttp.dll?PrePayEUserP'
      }
    }.freeze

    PUBLIC_KEY = File.read(File.expand_path('./public.key', __dir__)).freeze

    def self.request_gateway_url(api_action)
      GATEWAY_URL[CmbPay.environment.to_sym][api_action.to_sym]
    end

    def self.request_uri(api_action, params)
      uri = URI(request_gateway_url(api_action))
      uri.query = "#{uri.query}?#{URI.encode_www_form(params)}"
      uri
    end
  end
end
