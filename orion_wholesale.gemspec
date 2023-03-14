# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'orion_wholesale/version'

Gem::Specification.new do |spec|
  spec.name          = "orion_wholesale"
  spec.version       = OrionWholesale::VERSION
  spec.authors       = ["Tony Beninate"]
  spec.email         = ["tonybeninate@icloud.com"]

  spec.summary       = %q{Ruby library for OrionWholesale}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", ">= 5"
  spec.add_runtime_dependency "net-sftp"

  spec.add_development_dependency "bundler", ">= 1.15"
  spec.add_development_dependency "rake", "~> 12.3.0"
  spec.add_development_dependency "rspec", "~> 3.7"
end
