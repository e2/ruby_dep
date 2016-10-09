module RubyDep
  class Logger
    def initialize(device, prefix)
      @device = device
      @prefix = prefix
      ::RubyDep.logger.warn("The RubyDep::Logger class is deprecated")
    end

    def warning(msg)
      @device.puts @prefix + msg
    end

    def notice(msg)
      @device.puts @prefix + msg
    end
  end
end
