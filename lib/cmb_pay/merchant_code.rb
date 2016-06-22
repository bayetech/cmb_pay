require 'base64'

module CmbPay
  module MerchantCode
    # 产生商户校验码
    #
    # * +random+ - 随机数
    # * +strkey+ - 商户密钥
    # * +date+ - 订单日期
    # * +branch_id+ - 开户分行号
    # * +co_no+ - 商户号
    # * +bill_no+ - 订单号
    # * +amount+ - 订单金额
    # * +merchant_para+ - 商户自定义参数
    # * +merchant_url+ - 商户接受通知的URL
    # * +payer_id+ - 付款方用户标识。用来唯一标识商户的一个用户。长度限制为40字节以内。
    # * +payee_id+ - 收款方的用户标识。生成规则同上。不要求商户提供用户的注册名称，但需要保证一个用户对应一个UserID。
    # * +client_ip+ - 商户取得的客户端IP，如果有多个IP用逗号','分隔。长度限制为64字节。
    # * +goods_type+ - 商品类型编码，长度限制为8字节。
    # * +reserved+ - 保留字段，长度限制为1024字节。
    def self.generate(random: '3.14', strkey:, date:, branch_id:, co_no:, bill_no:,
                 amount:, merchant_para:, merchant_url:,
                 payer_id:, payee_id:, client_ip: nil, goods_type: nil, reserved: '')
      '|aGpDsEcbmOuYcSeT5rQhnl0Z18OKkuAJlvDJXaex3KJXCn7KJ9XYfiw*UhIW6/a*YRTH1ImLwYPMybevPLIOUx1y6WdEnfv84loW9JF8nvw3Hsv/IWQpLd80SawuxobNab5OMOxpLg==|acdc1b7113a47324c2209626d11fa632e1210b1c'
    end
  end
end
