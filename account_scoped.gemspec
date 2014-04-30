# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'account_scoped/version'

Gem::Specification.new do |spec|
  spec.name          = "account_scoped"
  spec.version       = AccountScoped::VERSION
  spec.authors       = ["Remus Rusanu"]
  spec.email         = ["contact@rusanu.com"]
  spec.description   = %q{ActiveRecord multi-tenency scope based on current account}
  spec.summary       = %q{Adds account_scoped method to controllers and models}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
