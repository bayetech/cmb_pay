# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cmb_pay/version'

Gem::Specification.new do |spec|
  spec.name          = 'cmb-pay'
  spec.version       = CmbPay::VERSION
  spec.authors       = ['Eric Guo']
  spec.email         = ['eric.guocz@gmail.com']

  spec.summary       = 'An unofficial cmb (China Merchants Bank) pay gem.'
  spec.description   = 'Helping rubyist integration with cmb (China Merchants Bank) payment service easier.'
  spec.homepage      = ''
  spec.license       = 'MIT'
  spec.required_ruby_version = '~> 2.1'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'http', '>= 1.0.4', '< 3'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 11.2'
  spec.add_development_dependency 'rspec', '~> 3.4'
end
