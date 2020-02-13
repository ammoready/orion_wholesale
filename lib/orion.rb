require 'orion/version'

require 'csv'
require 'net/ftp'
require 'tempfile'

require 'nokogiri'
require 'active_support/all'

require 'orion/base'
require 'orion/catalog'
require 'orion/category'
require 'orion/inventory'
require 'orion/order'
require 'orion/tracking'
require 'orion/user'

module Orion
  class InvalidOrder < StandardError; end
  class NotAuthenticated < StandardError; end
  class FileOrDirectoryNotFound < StandardError; end

  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    attr_accessor :debug_mode
    attr_accessor :ftp_host
    attr_accessor :top_level_dir

    def initialize
      @debug_mode    ||= false
      @ftp_host      ||= "ftp.mgegroup.com"
      @top_level_dir ||= "ffldealer"
    end
  end
end
