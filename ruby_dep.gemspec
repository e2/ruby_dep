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

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host' to allow pushing to a single host or delete this
  # section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems >= 2.0 required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12.a'
end
