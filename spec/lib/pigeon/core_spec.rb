require_relative '../../spec_helper'

describe Pigeon::Core do
  subject {
    described_class.new(
      config_file: File.expand_path('../../../assets/config/sample.yml', __FILE__)
    )
  }

  describe '#initialize' do
    context 'when successfully instantiated' do
      it { expect(subject).to be_an_instance_of described_class }
      it { expect(subject.config).to be_an_instance_of Hash     }
    end

    context 'when no config file name passed in' do
      it {
        expect { described_class.new }.to raise_error(ArgumentError)
      }
    end
  end
end
