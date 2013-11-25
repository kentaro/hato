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
      let(:payload) {
        {
          repository: {
            name:  'hato',
            owner: {
              name: 'kentaro',
            },
          }
        }
      }
      it 'should be success with correct payload' do
        post '/webhook', payload: payload, api_key: 'test'
        expect(last_response).to be_ok
        expect(last_response.body).to eq('{"status":"success","message":"Successfully sent the message you notified to me."}')
      end
    end

    context 'error' do
      it 'should be error when payload is not passed' do
        post '/webhook', api_key: 'test'
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq('{"status":"error","message":"Missing mandatory parameter: `payload`"}')
      end

      it 'should be error when repository.name is not passed' do
        post '/webhook', api_key: 'test', payload: {repository: {owner: {name: 'kentaro'}}}
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq('{"status":"error","message":"Invalid JSON message: both `repository.owner.name` and `repository.name` are required"}')
      end

      it 'should be error when repository.owner.name is not passed' do
        post '/webhook', api_key: 'test', payload: {repository: {name: 'hato'}}
        expect(last_response).to be_bad_request
        expect(last_response.body).to eq('{"status":"error","message":"Invalid JSON message: both `repository.owner.name` and `repository.name` are required"}')
      end
    end
  end
end
