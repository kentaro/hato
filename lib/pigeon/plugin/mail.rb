require 'mail'

module Pigeon
  module Plugin
    class Mail < Base
      def notify(args)
        send_mail(args[:message])
      end

      protected

      def send_mail(message='')
        smtp_opts = @config['smtp'].keys.inject({}) do |opts, key|
          opts[key.to_sym] = @config['smtp'][key]
          opts
        end

        ::Mail.defaults do
          delivery_method :smtp, smtp_opts
        end

        to_addresses = @config['message']['to'] || []
        mail = {
          from:    @config['message']['from'],
          subject: @config['message']['subject'],
        }

        to_addresses.each do |to_address|
          ::Mail.deliver do
            from    mail[:from]
            to      to_address
            subject mail[:subject]
            body    message
          end
        end
      end
    end
  end
end
