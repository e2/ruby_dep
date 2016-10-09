require 'ruby_dep/warning'

# Monkey patch so warning happens on every tested Ruby version
module RubyDep
  class RubyVersion
    def status
      :insecure
    end
  end
end

RubyDep.logger = Logger.new(STDOUT).tap do |logger|
  logger.formatter = proc do |severity,_,_,msg|
    "#{severity};"
  end
end
RubyDep::Warning.new.show_warnings
