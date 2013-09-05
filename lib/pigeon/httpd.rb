require 'sinatra'
require 'json'

require 'pigeon/plugin'

module Pigeon
  class Httpd < Plugin::Base
    def run
      App.set(:observer, @observer)
      App.set(:api_key,  @config['api_key'])

      Rack::Handler::WEBrick.run(
        App.new,
        Host: @config['host'] || '0.0.0.0',
        Port: @config['port'] || 9699,
      )
    end
  end

  class App < Sinatra::Base
    before do
      if settings.api_key != params[:api_key]
        halt 403, JSON.dump(
          status:  :error,
          message: 'API key is wrong. Confirm your API key setting of server/client.',
        )
      end
    end

    post "/notify" do
      settings.observer.update(
        type:    :notice,
        message: params[:message],
      )

      JSON.dump(
        status:  :success,
        message: 'Successfully sent the message you notified to me.',
      )
    end
  end
end
