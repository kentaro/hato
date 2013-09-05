require 'yaml'

module Pigeon
  class Core
    attr_accessor :config

    def initialize(opts={})
      @config = load_config(opts[:config_file])
    end

    private

    def load_config(config_file)
      if !config_file
        raise ArgumentError.new('missing mandatory parameter: config_file')
      end

      YAML.load_file(config_file)
    end
  end
end
