require_relative 'lib/monobank/version'

Gem::Specification.new do |spec|
  spec.name          = 'monobank'
  spec.version       = Monobank::VERSION
  spec.authors       = %w(vergilet anatoliikryvishyn)
  spec.email         = ["osyaroslav@gmail.com"]

  spec.description   = %q{Unofficial Ruby Gem for Monobank API.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/vergilet/monobank"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vergilet/monobank"
  spec.metadata["changelog_uri"] = "https://github.com/vergilet/monobank"

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'hashable', '~> 0.1.2'
  spec.add_dependency 'httparty', '~> 0.17.3'
end
