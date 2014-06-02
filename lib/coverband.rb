require 'redis'
require 'logger'

require 'coverband/version'
require 'coverband/configuration'
require 'coverband/redis_store'
require 'coverband/base'
require 'coverband/reporter'
require 'coverband/middleware'
require 'coverband/coverage_base'
require 'coverband/coverage_middleware'

module Coverband

  class << self
    attr_accessor :configuration
  end

  def self.parse_baseline(baseline_file = './tmp/coverband_baseline.json')
    baseline = if File.exist?(baseline_file)
      JSON.parse(File.read(baseline_file))
    else
      {}
    end
  end

  def self.configure(file = nil)
    self.configuration ||= Configuration.new
    if block_given?
      yield(configuration)
    else
      file ||= './config/coverband.rb'
      require file
    end
  end
  
end
