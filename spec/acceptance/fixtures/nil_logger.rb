require 'ruby_dep/warning'

# Monkey patch so warning happens on every tested Ruby version
module RubyDep
  class RubyVersion
    def status
      :insecure
    end
  end
end

RubyDep.logger = nil
RubyDep::Warning.new.show_warnings
