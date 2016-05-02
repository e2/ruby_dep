# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_dep/version'

# Yes, inception: we're using this ourselves
require 'ruby_dep/travis'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_dep'
  spec.version       = RubyDep::VERSION
  spec.authors       = ['Cezary Baginski']
  spec.email         = ['cezary@chronomantic.net']

  spec.summary       = 'Extracts supported Ruby versions from Travis file'
  spec.description   = 'Creates a version constraint of supported Rubies,' \
    'suitable for a gemspec file'
  spec.homepage      = 'https://github.com/e2/ruby_dep'
  spec.license       = 'MIT'

  spec.required_ruby_version = RubyDep::Travis.new.version_constraint

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(
      %r{^
      (?:
       (?:test|spec|features)
      /) # directories
      |
      (?:
       (?:bin/console|bin/setup|Rakefile|Gemfile|Guardfile|ruby_dep\.gemspec)
      $) # files
      }x
    )
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
end
