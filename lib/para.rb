module Para
  PREFIX = File.dirname(__FILE__)

  def self.clean_trace(trace)
    trace.reject { |line| line.include?(Para::PREFIX) }
  end
end

require "#{Para::PREFIX}/para/base"
require "#{Para::PREFIX}/para/version"
require "#{Para::PREFIX}/para/assertions"
require "#{Para::PREFIX}/para/should"
require "#{Para::PREFIX}/para/contest"
