require 'erb'
require 'mail'

module Pigeon
  module Plugin
    class Mail < Base
      def notify(args)
        if smtp_opts = config.smtp
          ::Mail.defaults do
            delivery_method :smtp, smtp_opts
          end
        end

        to_addresses = config.message['to']
        if to_addresses.is_a?(String)
          to_addresses = [to_addresses]
        end

        mail = {
          from:    config.message['from'],
          subject: render(config.message['subject_template'], args),
          body:    render(config.message['body_template'], args),
        }

        to_addresses.each do |to_address|
          ::Mail.deliver do
            from    mail[:from]
            to      to_address
            subject mail[:subject]
            body    mail[:body]
          end
        end
      end

      protected

      def render(template, args)
        erb = ERB.new(template)
        erb.result(binding)
      end
    end
  end
end
