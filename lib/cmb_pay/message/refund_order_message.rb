require 'rexml/document'

module CmbPay
  class RefundOrderMessage
    attr_reader :raw_http_response, :code, :error_message
    def initialize(http_response)
      @raw_http_response = http_response
      return unless http_response.code == 200

      document_root = REXML::Document.new(http_response.body.to_s).root
      head = document_root.elements['Head']
      @code          = head.elements['Code'].text
      @error_message = head.elements['ErrMsg'].text
      return unless succeed?

      body = document_root.elements['Body']
    end

    def succeed?
      code.nil? && error_message.nil?
    end
  end
end
