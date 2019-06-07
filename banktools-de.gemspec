# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'banktools-de/version'

Gem::Specification.new do |spec|
  spec.name          = "banktools-de"
  spec.version       = BankTools::DE::VERSION
  spec.authors       = [ "Henrik Nyh" ]
  spec.email         = [ "henrik@nyh.se" ]
  spec.summary       = %q{Validate and normalize German Bankleitzahl (BLZ) and bank account numbers. Also it converts BLZ to IBAN/BIC.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "attr_extras", ">= 4"
  spec.add_dependency "memoit"
  spec.add_dependency "ibanizator"  # Convert BLZ to IBAN and lookup BIC from IBAN
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "creek"  # XLSX parsing
end
