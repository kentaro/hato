require 'hato/version'
require 'hato/config'
require 'hato/observer'
require 'hato/httpd'

module Hato
  def self.run(opts = {})
    config   = Config.load(opts[:config_file])
    observer = Observer.new(config)
    server   = Httpd.new(observer, config)

    server.run
  end
end
