# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_model_serializers/namespaces/version'

Gem::Specification.new do |spec|
  spec.name          = "active_model_serializers-namespaces"
  spec.version       = ActiveModelSerializers::Namespaces::VERSION
  spec.authors       = ["Sebastian Skałacki"]
  spec.email         = ["skalee@gmail.com"]
  spec.summary       = %q{Namespaces support for ActiveModel::Serializers.}
  spec.description   = %q{Enhances ActiveModel::Serializers gem by adding } +
                       %q{support for serializers namespacing.  This makes } +
                       %q{developing versioned APIs super easy.  Works with } +
                       %q{ActiveModel::Serializers 0.8.x series.}
  spec.homepage      = "https://github.com/skalee/active_model_serializers-namespaces"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "active_model_serializers", "~> 0.8.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"

  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "rails", ">= 3.2"
end
