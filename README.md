# RubyDep

Helps with various Ruby version management activities, such as:

1. Reading supported Ruby version from a .travis.yml file
2. More stuff planned (reading TargetRubyVersion from .rubocop.yml file?)

Reason: tests are the best indicator of compatibility.

So, it doesn't make mention the supported Ruby version(s) in:

1. your gemspec
2. your README
3. your .travis.yml file

(That breaks the principle of single responsibility).

Instead, it's better to:

- point to the Travis build in your README (or your gem home page on rubygems.org)
- extract the supported versions from your .travis.yml
- set the versions automatically in your Gemspec


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_dep'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_dep

## Usage

E.g. in your gemspec file:

```ruby
require 'ruby_dep'

# (...)

spec.required_ruby_version = RubyDep::Travis.new.version_constraint
```

## Development

Use `rake` to run tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/e2/ruby_dep.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
