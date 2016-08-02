module RubyDep
  class Logger
    def initialize(device, prefix)
      @device = device
      @prefix = prefix
    end

    def warning(msg)
      @device.puts @prefix + msg
    end

    def notice(msg)
      @device.puts @prefix + msg
    end
  end
end
