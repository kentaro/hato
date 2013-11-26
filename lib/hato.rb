require 'hato/version'
require 'hato/config'
require 'hato/observer'
require 'hato/httpd'

module Hato
  def self.run(opts = {})
    config           = Config.load(opts[:config_file])
    config.log_level = opts[:log_level] || 'info'
    observer         = Observer.new(config)
    server           = Httpd.new(observer, config)

    server.run
  end
end
