require 'ruby_dep/logger'

RSpec.describe RubyDep::Logger do
  let(:device) { instance_double(IO) }

  describe '#warning' do
    context 'with a prefix' do
      subject { described_class.new(device, 'foo: ') }
      it 'outputs message with prefix' do
        expect(device).to receive(:puts).with('foo: bar')
        subject.warning('bar')
      end
    end
  end

  describe '#notice' do
    context 'with a prefix' do
      subject { described_class.new(device, 'foo: ') }
      it 'outputs message with prefix' do
        expect(device).to receive(:puts).with('foo: bar')
        subject.notice('bar')
      end
    end
  end
end
