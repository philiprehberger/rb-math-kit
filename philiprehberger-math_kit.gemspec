# frozen_string_literal: true

require_relative 'lib/philiprehberger/math_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'philiprehberger-math_kit'
  spec.version       = Philiprehberger::MathKit::VERSION
  spec.authors       = ['Philip Rehberger']
  spec.email         = ['me@philiprehberger.com']
  spec.summary       = 'Statistics, interpolation, rounding modes, and moving averages for Ruby'
  spec.description   = 'Descriptive statistics, linear interpolation, rounding modes, and moving averages. ' \
                       'Lightweight math toolkit with zero dependencies.'
  spec.homepage      = 'https://github.com/philiprehberger/rb-math-kit'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'
  spec.metadata['homepage_uri']          = spec.homepage
  spec.metadata['source_code_uri']       = spec.homepage
  spec.metadata['changelog_uri']         = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']       = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'
  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
