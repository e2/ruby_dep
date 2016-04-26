require 'ruby_dep/warning'

RSpec.describe RubyDep::Warning do
  before do
    allow(STDERR).to receive(:puts)
    stub_const('RUBY_VERSION', ruby_version)
  end

  describe '#show_warnings' do
    context 'with an up-to-date Ruby' do
      let(:ruby_version) { '2.3.1' }
      it 'does not show warning' do
        expect(STDERR).to_not receive(:puts)
        subject.show_warnings
      end
    end

    context 'with a secure but buggy Ruby' do
      let(:ruby_version) { '2.2.4' }
      it 'shows warning about bugs' do
        expect(STDERR).to receive(:puts).with(
          'RubyDep: WARNING: your Ruby is outdated/buggy. Please upgrade.')
        subject.show_warnings
      end
    end

    context 'with an insecure Ruby' do
      let(:ruby_version) { '2.2.3' }
      it 'shows warning about vulnerability' do
        expect(STDERR).to receive(:puts).with(
          'RubyDep: WARNING: your Ruby has security vulnerabilities!'\
          ' Please upgrade!')
        subject.show_warnings
      end
    end

    context 'with an unsupported Ruby' do
      let(:ruby_version) { '1.9.3' }
      it 'shows warning about vulnerability' do
        expect(STDERR).to receive(:puts).with(
          'RubyDep: WARNING: your Ruby has security vulnerabilities!'\
          ' Please upgrade!')
        subject.show_warnings
      end
    end
  end
end
