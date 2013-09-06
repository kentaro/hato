require 'pigeon/version'
require 'pigeon/config'
require 'pigeon/httpd'
require 'pigeon/observer'

module Pigeon
  def self.run(opts = {})
    config   = Config.load(opts[:config_file])
    observer = Observer.new(config)

    trap('INT') { server.shutdown }
    server = Httpd.new(observer, config)
    server.run
  end
end
