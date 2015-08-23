# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'charlotte_budget/version'

Gem::Specification.new do |spec|
  spec.name          = "charlotte_budget"
  spec.version       = CharlotteBudget::VERSION
  spec.authors       = ["Jim Van Fleet"]
  spec.email         = ["jim@jimvanfleet.com"]

  spec.summary       = %q{Process the City of Charlotte budget}
  spec.description   = %q{ETL system for the CSV file(s) of open data to support visualization efforts.}
  spec.homepage      = "http://www.codeforcharlotte.org/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency 'kiba', '~> 0.6.1'
  spec.add_runtime_dependency 'multi_json', '~> 1.11.2'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
