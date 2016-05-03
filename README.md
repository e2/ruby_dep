# RubyDep

[![Gem Version](https://img.shields.io/gem/v/ruby_dep.svg?style=flat)](https://rubygems.org/gems/ruby_dep) [![Build Status](https://travis-ci.org/e2/ruby_dep.svg)](https://travis-ci.org/e2/ruby_dep)

NOTE: For currently supported Ruby versions, [check out the Travis build status](https://travis-ci.org/e2/ruby_dep). If you need support for an different/older version of Ruby, open an issue with "backport" in the title and provide a compelling case for supporting the version of Ruby you need. When in doubt, open a new issue or [read the FAQ on the Wiki](https://github.com/e2/ruby_dep/wiki/FAQ).


## The problem

Your gem shouldn't (and likely doesn't) support all possible Ruby versions.

(And not all Ruby versions are secure to even be installed).

You need a way to protect users who don't know about this. So, you need to tell users which Ruby versions you support in:

1. Your gemspec
2. Your README
3. Your .travis.yml file
4. Any issues you get about which version of Ruby is supported or not

But, maintaning that information in 4 different places breaks the principle of
single responsibility.

And users often don't really "read" a README if they can avoid it.


## The solution

This gem helps you and your project users avoid Ruby version problems by:

- warning users if their Ruby is seriously outdated or contains serious vulnerabilities
- helps you manage which Ruby versions you actually support (and prevents installing other versions)

How? This gems detects which Ruby version users are using and which ones your project supports.

It assumes you are using Travis and the versions listed in your `.travis.yml` are supported.

This helps you limit the Ruby versions you support - just by adding/removing entries in your Travis configuration file.

Also, you it can warn users if they are using an outdated version of Ruby.

(Or one with security vulnerabilities).


## Usage

### E.g. in your gemspec file:

```ruby
  begin
    require "ruby_dep/travis"
    s.required_ruby_version = RubyDep::Travis.new.version_constraint
  rescue LoadError
    abort "Install 'ruby_dep' gem before building this gem"
  end

  s.add_development_dependency 'ruby_dep', '~> 1.1'
```

### In your `README.md`:

Replace your mentions of "supported Ruby versions" to point to the Travis build.

If users see their Ruby version "green" on Travis, it suggests it's supported, right?

(Or, you can point to the rubygems.org site where the required Ruby version is listed).


### In your library:

```ruby
require 'ruby_dep/warnings'
RubyDep::Warning.show_warnings
```

## Tips

To disable warnings, just set the following environment variable:

`RUBY_DEP_GEM_SILENCE_WARNINGS=1`

You can follow these rules of thumb, whether you use RubyDep or not:

1. Avoid changing major version numbers, even if you're dropping a major version of Ruby (e.g. 1.9.2)
2. If you want to support a current version, add it to your `.travis.yml` (e.g. ruby-2.3.1)
3. To support an earlier version of Ruby, add it to your `.travis.yml` and release a new gem version.
4. If you want to support a range of Rubies, include the whole range without gaps in minor version numbers (e.g. 2.0.0, 2.1.0, 2.2.0, 2.3.0) and ruby_dep will use the whole range. (If there's a gap, older versions will be considered "unsupported")
5. If you just want to test a Ruby version (but not actually support it), put it into the "allow failures" part of your Travis build matrix. (ruby_dep ignores versions there).
6. If you want to drop support for a Ruby, remove it from the `.travis.yml` and just bump your gem's minor number.

When in doubt, open an issue and just ask.


## Roadmap

Pull Requests are welcome.

Plans include: reading supported Ruby from `.rubocop.yml` (`TargetRubyVersion` field).


## Development

Use `rake` to run tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/e2/ruby_dep.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
