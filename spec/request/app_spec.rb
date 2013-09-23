ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'hato'
require 'rack/test'

describe 'Hato::Httpd' do
  include Rack::Test::Methods

  def app
    config = Hato::Config.load(
      File.expand_path('../../assets/config/test.rb', __FILE__)
    )
    observer = Hato::Observer.new(config)
    Hato::Httpd::App.set(:observer, observer)
    Hato::Httpd::App.set(:api_key,  config.api_key)
    Hato::Httpd::App.new
  end

  describe 'index' do
    it do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Hato https://github.com/kentaro/hato')
    end
  end

  describe 'notify' do
    it 'success' do
      post '/notify', {message: 'test', tag: 'test', api_key: 'test'}
      expect(last_response).to be_ok
      expect(last_response.body).to eq('{"status":"success","message":"Successfully sent the message you notified to me."}')
    end

    it 'fail' do
      post '/notify', {message: 'test', tag: 'test', api_key: 'wrong_key'}
      expect(last_response).to be_forbidden
      expect(last_response.body).to eq('{"status":"error","message":"API key is wrong. Confirm your API key setting of server/client."}')
    end
  end
end
