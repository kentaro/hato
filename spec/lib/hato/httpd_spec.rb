ENV['RACK_ENV'] = 'test'

require 'spec_helper'
require 'rack/test'

describe Hato::Httpd do
  include Rack::Test::Methods

  let(:config) {
    config = Hato::Config.load(
      File.expand_path('../../../assets/config/test.rb', __FILE__)
    )
  }

  def app
    @_app ||= -> {
      observer = Hato::Observer.new(config)
      Hato::Httpd::App.set(:observer, observer)
      Hato::Httpd::App.set(:api_key,  config.api_key)
      Hato::Httpd::App.new
    }.call
  end

  describe 'index' do
    it 'should return response' do
      get '/'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('Hato https://github.com/kentaro/hato')
    end
  end

  describe 'notify' do
    context 'success' do
      context 'when api_key is set' do
        it 'should be success with correct api_key' do
          post '/notify', {message: 'test', tag: 'test', api_key: 'test'}
          expect(last_response).to be_ok
          expect(last_response.body).to eq('{"status":"success","message":"Successfully sent the message you notified to me."}')
        end
      end

      context 'when api_key is not set' do
        before { app.settings.api_key = nil            }
        after  { app.settings.api_key = config.api_key }

        it 'should be success without api_key' do
          post '/notify', {message: 'test', tag: 'test'}
          expect(last_response).to be_ok
          expect(last_response.body).to eq('{"status":"success","message":"Successfully sent the message you notified to me."}')
        end
      end
    end

    context 'error' do
      it 'should be error when api_key is wrong' do
        post '/notify', {message: 'test', tag: 'test', api_key: 'wrong_key'}
        expect(last_response).to be_forbidden
        expect(last_response.body).to eq('{"status":"error","message":"API key is wrong. Confirm your API key setting of server/client."}')
      end
    end
  end

  describe 'webhook' do
    context 'success' do
      it 'should be success with correct payload' do
        post '/webhook/kentaro/hato', payload: {foo: 'bar'}, api_key: 'test'
        expect(last_response).to be_ok
        expect(last_response.body).to eq('{"status":"success","message":"Successfully sent the message you notified to me."}')
      end
    end

    context 'error' do
      it 'should be error when payload is not passed' do
        post '/webhook/kentaro/hato', api_key: 'test'
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq('{"status":"error","message":"Missing mandatory parameter: `payload`"}')
      end
    end
  end
end
