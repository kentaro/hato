# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hato/version'

Gem::Specification.new do |spec|
  spec.name          = "hato"
  spec.version       = Hato::VERSION
  spec.authors       = ["Kentaro Kuribayashi"]
  spec.email         = ["kentarok@gmail.com"]
  spec.description   = %q{A Notification Management Tools}
  spec.summary       = %q{A Notification Management Tools}
  spec.homepage      = "https://github.com/kentaro/hato"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 1.9.2'

  spec.executables   = ["hato"]
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sinatra"
  spec.add_dependency "sinatra-logger"
  spec.add_dependency "mail"
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
