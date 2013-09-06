module Pigeon
  module Plugin
    class Base
      attr_reader :config

      def initialize(config)
        @config = config
      end
    end
  end
end
