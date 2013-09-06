require 'yaml'
require 'hashie'

module Hato
  module Config
    module DSL
      attr_accessor :name

      def initialize(name, &block)
        @name = name
        instance_eval(&block)
      end

      def method_missing(method, *args)
        config.send(method)
      end

      private

      def config
        @config ||= Hashie::Mash.new
      end
    end

    extend DSL

    def self.load(config_file)
      Kernel.load(config_file)
      @loaded = true
      self
    end

    def self.loaded?
      @loaded
    end

    def self.define(&block)
      instance_eval(&block)
    end

    def self.tags
      @tags ||= []
    end

    def self.tag(name, &block)
      self.tags << Tag.new(name, &block)
    end

    def self.match(tag)
      tags.select { |t| t.name == tag }
    end

    def self.reset
      @loaded = false
      @config = nil
      @tags   = nil
    end

    class Tag
      include DSL

      def plugins
        @plugins ||= []
      end

      def plugin(name, &block)
        self.plugins << Plugin.new(name, &block)
      end
    end

    class Plugin
      include DSL
    end
  end
end
