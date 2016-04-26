module RubyDep
  class Warning
    MSG_BUGGY = 'RubyDep: WARNING: your Ruby is outdated/buggy.'\
      ' Please upgrade.'.freeze

    MSG_INSECURE = 'RubyDep: WARNING: your Ruby has security vulnerabilities!'\
      ' Please upgrade!'.freeze

    MSG_HOW_TO_DISABLE = ' (To disable warnings, set'\
      ' RUBY_DEP_GEM_SILENCE_WARNINGS=1)'.freeze

    def show_warnings
      return if silenced?
      case check_ruby
      when :insecure
        STDERR.puts MSG_INSECURE + MSG_HOW_TO_DISABLE
      when :buggy
        STDERR.puts MSG_BUGGY + MSG_HOW_TO_DISABLE
      when :unknown
      else
        raise "Unknown problem type: #{problem.inspect}"
      end
    end

    private

    VERSION_INFO = {
      '2.3.1' => :unknown,
      '2.3.0' => :buggy,
      '2.2.5' => :unknown,
      '2.2.4' => :buggy,
      '2.2.0' => :insecure,
      '2.1.9' => :buggy,
      '2.0.0' => :insecure
    }.freeze

    def check_ruby
      version = Gem::Version.new(RUBY_VERSION)
      VERSION_INFO.each do |ruby, status|
        return status if version >= Gem::Version.new(ruby)
      end
      :insecure
    end

    def silenced?
      value = ENV['RUBY_DEP_GEM_SILENCE_WARNINGS']
      (value || '0') !~ /^0|false|no|n$/
    end
  end
end
