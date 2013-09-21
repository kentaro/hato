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

  it "index" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hato https://github.com/kentaro/hato')
  end
end
