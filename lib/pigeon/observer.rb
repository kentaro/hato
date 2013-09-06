module Pigeon
  class Observer
    def initialize(config)
      @config = config
    end

    def update(args)
      plugins = load_plugins_for(args[:tag])
      plugins.each do |plugin|
        Thread.start(plugin) { plugin.notify(args) }
      end
    end

    protected

    def load_plugins_for(tag)
      plugins = []

      @config.match(tag).each do |matched|
        matched.plugins.each do |plugin|
          plugin_file_name = file_name_for(plugin.name)
          require plugin_file_name

          plugin_class = plugin_class_for(plugin.name)
          plugins << plugin_class.new(plugin)
        end
      end

      plugins
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
