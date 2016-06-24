CmbPay [![Gem Version][version-badge]][rubygems] [![Build Status][travis-badge]][travis] [![Code Climate][codeclimate-badge]][codeclimate] [![Code Coverage][codecoverage-badge]][codecoverage]
======

An unofficial cmb (China Merchants Bank) pay ruby gem, inspired from [alipay](https://github.com/chloerei/alipay), [wx_pay](https://github.com/jasl/wx_pay) and [cmbchina](https://github.com/yellong/cmbchina) a lot.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cmb-pay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cmb-pay

## Usage

### Config

Create `config/initializers/cmb_pay.rb` and put following configurations into it.

```ruby
# required
CmbPay.branch_id = 'xxxx' # 支付商户开户分行号，4位
CmbPay.co_no = '123456'   # 支付商户号/收单商户号，6位长数字，由银行在商户开户时确定
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/cmb-pay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[version-badge]: https://badge.fury.io/rb/cmb-pay.svg
[rubygems]: https://rubygems.org/gems/cmb-pay
[travis-badge]: https://travis-ci.org/bayetech/cmb-pay.svg
[travis]: https://travis-ci.org/bayetech/cmb-pay
[codeclimate-badge]: https://codeclimate.com/github/bayetech/cmb-pay.png
[codeclimate]: https://codeclimate.com/github/bayetech/cmb-pay
[codecoverage-badge]: https://codeclimate.com/github/bayetech/cmb-pay/coverage.png
[codecoverage]: https://codeclimate.com/github/bayetech/cmb-pay/coverage

