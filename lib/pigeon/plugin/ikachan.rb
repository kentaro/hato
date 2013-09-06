require 'uri'
require 'net/http'

module Pigeon
  module Plugin
    class Ikachan < Base
      def notify(args)
        send_request(:join)
        send_request(:notice, args[:message])
      end

      protected

      def send_request(action, message='')
        url = '%s://%s:%s/%s' % [
          config.scheme || 'http',
          config.host,
          config.port   || 4979,
          action.to_s,
        ]

        http = Net::HTTP.new(URI(url).host, URI(url).port)
        req  = Net::HTTP::Post.new(URI(url).path)

        req.form_data = {
          'channel' => "##{config.channel}",
          'message' => message,
        }
        http.request(req)
      end
    end
  end
end
