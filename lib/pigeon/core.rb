require 'yaml'

require 'pigeon/httpd'
require 'pigeon/plugin'
require 'pigeon/observer'

module Pigeon
  class Core
    def initialize(opts={})
      config   = load_config(opts[:config_file])
      observer = Pigeon::Observer.new

      @components = load_components(observer, config)
    end

    def run
      trap('INT') { exit! }
      Thread.abort_on_exception = true

      @components.map { |component|
        Thread.start(component) { component.run }
      }.each(&:join)
    end

    protected

    def load_config(config_file)
      if !config_file
        raise ArgumentError.new('missing mandatory parameter: config_file')
      end

      YAML.load_file(config_file)
    end

    def load_components(observer, config)
      components = [ Pigeon::Httpd.new(observer, config) ]

      plugins = config['plugins'] || {}
      plugins.keys.each do |name|
        plugin_file_name = file_name_for(name)
        require plugin_file_name

        plugin_class = Pigeon::Plugin.const_get(name.to_s)
        components << plugin_class.new(observer, plugins[name])
      end

      components
    end

    def plugin_class_for(name)
      Pigeon::Plugin.const_get(name.to_s)
    end

    def file_name_for(name)
      file_name = name.to_s.gsub(/[A-Z][a-z0-9_]+?/) { |s| "_#{s.downcase}" }
      'pigeon/plugin/' + file_name.sub(/^_/, '')
    end
  end
end
