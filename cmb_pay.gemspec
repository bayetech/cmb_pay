lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmb_pay/version'

Gem::Specification.new do |spec|
  spec.name          = 'cmb_pay'
  spec.version       = CmbPay::VERSION
  spec.authors       = ['Eric Guo']
  spec.email         = ['eric.guocz@gmail.com']

  spec.summary       = 'An unofficial cmb (China Merchants Bank) pay gem.'
  spec.description   = 'Helping rubyist integration with cmb (China Merchants Bank) payment service (招商银行一网通支付) easier.'
  spec.homepage      = 'https://github.com/bayetech/cmb_pay'
  spec.license       = 'MIT'
  spec.required_ruby_version = '~> 2.3'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) } \
    - %w(CODE_OF_CONDUCT.md cmb-pay.sublime-project Gemfile Rakefile cmb_pay.gemspec bin/setup bin/console certs/Eric-Guo.pem)
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.cert_chain  = ['certs/Eric-Guo.pem']
  spec.signing_key = File.expand_path('~/.ssh/gem-private_key.pem') if $PROGRAM_NAME.end_with?('gem')

  spec.add_runtime_dependency 'http', '>= 1.0.4', '< 5'
  spec.add_development_dependency 'rake', '~> 11.3'
  spec.add_development_dependency 'rspec', '~> 3.5'
end
