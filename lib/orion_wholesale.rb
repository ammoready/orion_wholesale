require 'orion_wholesale/version'

require 'csv'
require 'net/sftp'
require 'tempfile'

require 'active_support/all'

require 'orion_wholesale/base'
require 'orion_wholesale/catalog'
require 'orion_wholesale/category'
require 'orion_wholesale/inventory'
require 'orion_wholesale/order'
require 'orion_wholesale/tracking'
require 'orion_wholesale/user'

module OrionWholesale
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
    attr_accessor :ftp_port
    attr_accessor :top_level_dir
    attr_accessor :catalog_filename_prefix

    def initialize
      @debug_mode              ||= false
      @ftp_host                ||= "74.143.53.110"
      @ftp_port                ||= "10022"
      @top_level_dir           ||= "/ammoready"
      @catalog_filename_prefix ||= 'orion_inv_arweb'
    end
  end
end
