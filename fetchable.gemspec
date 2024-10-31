# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fetchable/version'

Gem::Specification.new do |spec|
  spec.name          = "fetchable"
  spec.version       = Fetchable::VERSION
  spec.authors       = ["Stephen Best", "Fable Tales"]
  spec.email         = ["bestie@gmail.com"]

  spec.summary       = %q{Provides a mixin and decorator to add a `Hash#fetch` like interface to any object.}
  spec.description   = spec.summary + " " + %{You must define a `[]` subscript method for raw access to the fetchable data.}
  spec.homepage      = "https://github.com/bestie/fetchable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.4"
  spec.add_development_dependency "rspec",   "~> 3.13"
  spec.add_development_dependency "pry",     "~> 0.14"
end
