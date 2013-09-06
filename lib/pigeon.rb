require 'pigeon/version'
require 'pigeon/config'
require 'pigeon/observer'
require 'pigeon/httpd'

module Pigeon
  def self.run(opts = {})
    config   = Config.load(opts[:config_file])
    observer = Observer.new(config)
    server   = Httpd.new(observer, config)

    server.run
  end
end
