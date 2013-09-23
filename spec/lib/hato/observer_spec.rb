require_relative '../../spec_helper'

describe Hato::Observer do
  describe '.update' do
    context "tag's name is String object in config" do
      before do
        Hato::Config.reset
        config = Hato::Config.load(
          File.expand_path('../../../assets/config/test.rb', __FILE__)
        )
        @observer = described_class.new(config)
      end

      it 'receive `invoke!` with nil' do
        logger = double('logger')
        logger.stub(:error).and_return(nil)

        Hato::Config::Tag.any_instance.should_receive(:invoke!).with(nil)

        @observer.update(
          tag:     'test',
          message: 'hello!',
          logger:  logger
        )
      end
    end

    context "tag's name is Regexp object in config" do
      before do
        Hato::Config.reset
        config = Hato::Config.load(
          File.expand_path('../../../assets/config/tags_name_regexp.rb', __FILE__)
        )
        @observer = described_class.new(config)
      end

      it 'receive `invoke!` with matched values' do
        logger = double('logger')
        logger.stub(:error).and_return(nil)

        Hato::Config::Tag.any_instance.should_receive(:invoke!).with(['Yang', 'Reinhard'])

        @observer.update(
          tag:     'Yang and Reinhard',
          message: 'hello!',
          logger:  logger
        )
      end
    end
  end
end
