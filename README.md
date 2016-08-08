CMB Pay [![Gem Version][version-badge]][rubygems] [![Build Status][travis-badge]][travis] [![Code Climate][codeclimate-badge]][codeclimate] [![Code Coverage][codecoverage-badge]][codecoverage]
=======

An unofficial cmb (China Merchants Bank) pay ruby gem, inspired from [alipay](https://github.com/chloerei/alipay), [wx_pay](https://github.com/jasl/wx_pay) and [cmbchina](https://github.com/yellong/cmbchina) a lot.

## Feature

* Payment URL generation for Web, App and WAP(Mobile Web).
* CMB Bank notification payment callback parse and verify.
* Direct refund API.
* Single order query.
* Multi orders query by transact/merchant date/settled date.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cmb_pay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cmb_pay

## Usage

### Config

Create `config/initializers/cmb_pay.rb` and put following configurations into it.

```ruby
# required
CmbPay.branch_id = '0755'     # 支付商户开户分行号，4位
CmbPay.co_no = '000056' # 支付商户号/收单商户号，6位长数字，由银行在商户开户时确定
CmbPay.co_key = ''            # 商户校验码/商户密钥，测试环境为空
CmbPay.environment = 'test' if Rails.env.development? || Rails.env.staging?
# only require by uri_of_pre_pay_euserp
CmbPay.mch_no = 'P0019844'    # 协议商户企业编号，或者说是8位虚拟企业网银编号
CmbPay.default_payee_id = '1' # 默认收款方的用户标识
# onlyl require if you need refund via cmb_pay (no need if you using CMB bank web)
CmbPay.operator = '9999'      # 操作员号，一般是9999
CmbPay.operator_password = '' # 操作员的密码，默认是支付商户号，但建议修改。
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bayetech/cmb_pay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[version-badge]: https://badge.fury.io/rb/cmb_pay.svg
[rubygems]: https://rubygems.org/gems/cmb_pay
[travis-badge]: https://travis-ci.org/bayetech/cmb_pay.svg
[travis]: https://travis-ci.org/bayetech/cmb_pay
[codeclimate-badge]: https://codeclimate.com/github/bayetech/cmb_pay/badges/gpa.svg
[codeclimate]: https://codeclimate.com/github/bayetech/cmb_pay
[codecoverage-badge]: https://codeclimate.com/github/bayetech/cmb_pay/badges/coverage.svg
[codecoverage]: https://codeclimate.com/github/bayetech/cmb_pay/coverage
