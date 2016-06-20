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

    def self.request_gateway_url(api_action)
      GATEWAY_URL[CmbPay.environment.to_sym][api_action.to_sym]
    end

    def self.request_uri(api_action, params, options = {})
      branch_id = options.delete(:branch_id)
      co_no = options.delete(:co_no)
      uri_params = {
        'BranchID' => branch_id || CmbPay.branch_id,
        'CoNo'     => co_no || CmbPay.co_no,
        'BillNo'   => params[:BillNo],
        'Amount'   => params[:Amount],
        'Date'     => Time.now.strftime('%Y%m%d'),
        'ExpireTimeSpan' => params[:ExpireTimeSpan] || 30,
        'MerchantUrl' => params[:MerchantUrl],
        'MerchantPara' => params[:MerchantPara],
        'MerchantCode' => 'xx', # TODO: Need implement
        'MerchantRetUrl' => params[:MerchantRetUrl],
        'MerchantRetPara' => params[:MerchantRetPara]
      }

      uri = URI(request_gateway_url(api_action))
      uri.query = URI.encode_www_form(uri_params)
      uri
    end
  end
end
