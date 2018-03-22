# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'im_helpers/version'

Gem::Specification.new do |spec|
  spec.name          = "im_helpers"
  spec.version       = ImHelpers::VERSION
  spec.authors       = ["julbouln"]
  spec.email         = ["jboulnois@immateriel.fr"]

  spec.summary       = %q{immat\u{e9}riel.fr helpers lib}
  spec.description   = %q{immat\u{e9}riel.fr helpers lib}
  spec.homepage      = "http://www.immateriel.fr"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_dependency 'nokogiri', '< 1.6.6'
  spec.add_dependency "iso-639", '~> 0.2.0'
  spec.add_dependency "countries", '~> 1.2.0'
  spec.add_dependency "currencies", '~> 0.4.0'
  spec.add_dependency "htmlentities", '~> 4.3.0'
  spec.add_dependency "html_truncator", "~> 0.4.0"
  spec.add_dependency "unidecoder"
  spec.add_dependency "unicode", "~> 0.4.0"
  spec.add_dependency "levenshtein-ffi"
  spec.add_dependency "activesupport", ">= 3.2.0"
  spec.add_dependency "i18n", ">= 0.7.0"
end
