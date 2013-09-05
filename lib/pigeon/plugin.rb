module Pigeon
  module Plugin
    class Base
      def initialize(observer, config)
        observer.observe(self)

        @observer = observer
        @config   = config
      end

      def run;          end
      def notify(args); end
    end
  end
end
