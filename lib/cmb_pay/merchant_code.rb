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
    # * +client_ips+ - 商户取得的客户端IP，如果有多个IP用逗号','分隔。长度限制为64字节。
    # * +goods_type+ - 商品类型编码，长度限制为8字节。
    # * +reserved+ - 保留字段，长度限制为1024字节。
    def self.generate(random: '3.14', strkey:, date:, branch_id:, co_no:, bill_no:,
                      amount:, merchant_para:, merchant_url:,
                      payer_id:, payee_id:, client_ips: nil, goods_type: nil, reserved: nil)
      last_3 = optional_last_3(client_ips: client_ips, goods_type: goods_type, reserved: reserved)
      combine_part1 = pay_to_in_rc4(random: random, strkey: strkey, payer_id: payer_id, payee_id: payee_id, opt_last_3: last_3)
      combine_part2 = "#{strkey}#{combine_part1}#{date}#{branch_id}#{co_no}#{bill_no}#{amount}#{merchant_para}#{merchant_url}"
      "|#{combine_part1}|#{Sign.sha1_digest(combine_part2)}"
    end

    private_class_method

    def self.pay_to_in_rc4(random:, strkey:, payer_id:, payee_id:, opt_last_3:)
      in_data = "#{random}|#{payer_id}<$CmbSplitter$>#{payee_id}#{opt_last_3}"
      key_md5_digest = Sign.md5_key_digest(strkey)
      encrypted = Sign.rc4_encrypt(key_md5_digest, in_data)
      Sign.encode_base64(encrypted)
    end

    def self.optional_last_3(client_ips: nil, goods_type: nil, reserved: nil)
      r = ''
      r << "<$ClientIP$>#{client_ips}</$ClientIP$>" unless client_ips.nil?
      r << "<$GoodsType$>#{goods_type}</$GoodsType$>" unless goods_type.nil?
      r << "<$Reserved$>#{reserved}</$Reserved$>" unless reserved.nil?
      r
    end
  end
end
