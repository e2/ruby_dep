require 'ruby_dep/logger'

RSpec.describe RubyDep do
  around do |example|
    example.run
    RubyDep.instance_variable_set(:@logger, nil)
  end

  let(:stderr_logger) { instance_double(Logger, 'stderr logger') }
  let(:null_logger) { instance_double(RubyDep::NullLogger, 'null logger') }

  let(:string_io) { instance_double(StringIO) }

  before do
    allow(StringIO).to receive(:new).and_return(string_io)
    allow(RubyDep::NullLogger).to receive(:new).and_return(null_logger)
    allow(Logger).to receive(:new).with(STDERR).and_return(stderr_logger)
  end

  describe '.logger' do
    context 'when not set yet' do
      before do
        allow(stderr_logger).to receive(:formatter=)
      end

      it 'returns stderr_logger' do
        expect(described_class.logger).to be(stderr_logger)
      end

      it 'sets up a simple formatter' do
        expect(stderr_logger).to receive(:formatter=) do |callback|
          expect( callback.call('a', 'b', 'c', 'd')).to eq("d\n")
        end
        described_class.logger
      end

      context 'when reset to nil' do
        before { described_class.logger = nil }

        it 'returns null logger' do
          expect(described_class.logger).to be(null_logger)
        end
      end

      context 'when set to a logger' do
        let(:logger) { instance_double(Logger) }
        before { described_class.logger = logger }

        it 'returns given logger' do
          expect(described_class.logger).to be(logger)
        end
      end
    end

    context 'when already set' do
      context 'with a custom logger' do
        let(:logger) { instance_double(Logger) }
        before { described_class.logger = logger }

        context 'when reset' do
          before { described_class.logger = nil }

          it 'outputs to null logger' do
            expect(described_class.logger).to be(null_logger)
          end
        end
      end
    end
  end
end
