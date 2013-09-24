require_relative '../../spec_helper'

describe Hato::Config do
  before { described_class.reset }

  describe '.load' do
    context 'success' do
      context 'when a config file is passed in' do
        before {
          described_class.load(
            File.expand_path('../../../assets/config/test.rb', __FILE__)
          )
        }

        it { expect(described_class.loaded?).to be_true }
      end
    end

    context 'failure' do
      context 'when a config file does not exist' do
        it {
          expect {
            described_class.load('no such file')
          }.to raise_error LoadError
        }
      end
    end
  end

  describe '.define' do
    context 'success' do
      context 'when a config file is passed in' do
        before {
          described_class.load(
            File.expand_path('../../../assets/config/test.rb', __FILE__)
          )
        }

        it {
          expect(described_class.api_key).to be == 'test'

          expect(described_class.tags).to be_an_instance_of Array
          expect(described_class.tags.size).to be == 1

          tag = described_class.tags.first
          tag.activate!
          expect(tag.plugins).to be_an_instance_of Array
          expect(tag.plugins.size).to be == 2

          ikachan = tag.plugins[0]
          expect(ikachan.name).to be == 'Ikachan'
          expect(ikachan.host).to be == 'irc.example.com'

          mail = tag.plugins[1]
          expect(mail.message).to be_an_instance_of Hashie::Mash
          expect(mail.message['from']).to be == 'hato@example.com'
        }
      end
    end
  end
end
