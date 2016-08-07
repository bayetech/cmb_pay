require 'rexml/streamlistener'

module CmbPay
  class BillRecordsMessage
    attr_reader :raw_http_response, :code, :error_message,
                :query_loop_flag, :query_loop_pos, :bill_records
    def initialize(http_response)
      @raw_http_response = http_response
      return unless http_response.code == 200
      @bill_records = []

      REXML::Document.parse_stream(http_response.body, self)
    end

    def tag_start(name, _attributes)
      case name
      when 'Head'
        @in_head = true
      when 'Body'
        @in_body = true
      when 'BllRecord'
        @current_bill_record = {}
      else
        @current_element_name = name
      end
    end

    def tag_end(name)
      case name
      when 'Head'
        @in_head = false
      when 'Body'
        @in_body = false
      when 'BllRecord'
        @bill_records << @current_bill_record
      end
    end

    def text(text)
      if @in_head
        case @current_element_name
        when 'Code'
          @code = text
        when 'ErrMsg'
          @error_message = text
        end
      elsif @in_body
        case @current_element_name
        when 'QryLopFlg'
          @query_loop_flag = text
        when 'QryLopBlk'
          @query_loop_pos = text
        when 'BillNo'
          @current_bill_record[:bill_no] = text
        when 'MchDate'
          @current_bill_record[:merchant_date] = text
        when 'StlDate'
          @current_bill_record[:settled_date] = text
        when 'BillState'
          @current_bill_record[:bill_state] = text
        when 'BillAmount'
          @current_bill_record[:bill_amount] = text
        when 'FeeAmount'
          @current_bill_record[:fee_amount] = text
        when 'CardType'
          @current_bill_record[:card_type] = text
        when 'BillRfn'
          @current_bill_record[:bill_ref_no] = text
        when 'BillType'
          @current_bill_record[:bill_type] = text
        when 'StlAmount'
          @current_bill_record[:settled_amount] = text
        when 'DecPayAmount'
          @current_bill_record[:discount_pay_amount] = text
        end
      end
    end

    def succeed?
      code.nil? && error_message.nil?
    end
  end
end
