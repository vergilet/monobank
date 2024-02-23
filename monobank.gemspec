require_relative 'lib/monobank/version'

Gem::Specification.new do |spec|
  spec.name          = 'monobank'
  spec.version       = Monobank::VERSION
  spec.authors       = %w(vergilet anatoliikryvishyn dreyks)
  spec.email         = ["osyaroslav@gmail.com"]

  spec.description   = %q{Unofficial Ruby Gem for Monobank API.}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/vergilet/monobank"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/vergilet/monobank"
  spec.metadata["changelog_uri"] = "https://github.com/vergilet/monobank"

  spec.files = Dir['{lib}/**/*', 'MIT-LICENSE', 'Rakefile']
  spec.test_files = Dir['spec/**/*']

  spec.add_dependency 'httparty', '>= 0.21.0', '< 0.22.0'
  
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.0'
  spec.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
  spec.add_development_dependency 'webmock'
end
