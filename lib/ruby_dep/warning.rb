module RubyDep
  class Warning
    MSG_BUGGY = 'RubyDep: WARNING: your Ruby is outdated/buggy.'\
      ' Please upgrade.'.freeze

    MSG_INSECURE = 'RubyDep: WARNING: your Ruby has security vulnerabilities!'\
      ' Please upgrade!'.freeze

    def show_warnings
      case check_ruby
      when :insecure
        STDERR.puts MSG_INSECURE
      when :buggy
        STDERR.puts MSG_BUGGY
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
  end
end
