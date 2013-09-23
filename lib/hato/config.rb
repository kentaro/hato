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
        if args.empty?
          config.send(method)
        else
          config[method] = args.first
        end
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
      tags.inject([]) do |buf, t|
        if t.name.kind_of?(String) && t.name == tag
          buf << [t]
        elsif t.name.kind_of?(Regexp) && (match = t.name.match(tag))
          buf << [t, match[1..-1]]
        end
        buf
      end
    end

    def self.reset
      @loaded = false
      @config = nil
      @tags   = nil
    end

    class Tag
      include DSL

      def initialize(name, &block)
        @name = name
        @block = block
      end

      def plugins
        @plugins ||= []
      end

      def plugin(name, &block)
        self.plugins << Plugin.new(name, &block)
      end

      def invoke!(args)
        @plugins = []
        if args && args.empty?
          instance_eval(&@block)
        else
          instance_exec(*args, &@block)
        end
        self
      end
    end

    class Plugin
      include DSL
    end
  end
end
