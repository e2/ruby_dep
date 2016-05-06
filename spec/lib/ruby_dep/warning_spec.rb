require 'ruby_dep/warning'

RSpec.describe RubyDep::Warning do
  before do
    stub_const('STDERR', instance_double(IO))
    stub_const('RUBY_VERSION', ruby_version)
    stub_const('RUBY_ENGINE', ruby_engine)
    allow(STDERR).to receive(:puts)
  end

  let(:ruby_engine) { 'ruby' }

  describe '#show_warnings' do
    before { subject.show_warnings }
    context 'when silenced' do
      around do |example|
        old = ENV['RUBY_DEP_GEM_SILENCE_WARNINGS']
        ENV['RUBY_DEP_GEM_SILENCE_WARNINGS'] = '1'
        example.run
        ENV['RUBY_DEP_GEM_SILENCE_WARNINGS'] = old
      end

      context 'with any outdated Ruby' do
        let(:ruby_version) { '1.9.3' }
        it 'does not show warning' do
          expect(STDERR).to_not have_received(:puts)
        end
      end
    end

    context 'when not silenced' do
      context 'with an up-to-date Ruby' do
        let(:ruby_version) { '2.3.1' }
        it 'does not show warning' do
          expect(STDERR).to_not have_received(:puts)
        end
      end

      context 'with a secure but buggy Ruby' do
        let(:ruby_version) { '2.2.4' }
        it 'shows warning about bugs' do
          expect(STDERR).to have_received(:puts).with(
            %r{RubyDep: WARNING: your Ruby is outdated\/buggy.})
        end
      end

      context 'with an insecure Ruby' do
        let(:ruby_version) { '2.2.3' }
        it 'shows warning about vulnerability' do
          expect(STDERR).to have_received(:puts).with(
            /RubyDep: WARNING: your Ruby has security vulnerabilities!/)
        end
      end

      context 'with an insecure base Ruby' do
        let(:ruby_version) { '2.2.0' }
        it 'shows warning about vulnerability' do
          expect(STDERR).to have_received(:puts).with(
            /RubyDep: WARNING: your Ruby has security vulnerabilities!/)
        end
      end

      context 'with an unsupported Ruby' do
        let(:ruby_version) { '1.9.3' }
        it 'shows warning about vulnerability' do
          expect(STDERR).to have_received(:puts).with(
            /RubyDep: WARNING: your Ruby has security vulnerabilities!/)
        end
      end

      context 'with JRuby' do
        context 'when the JRuby is not known to be vulnerable' do
          let(:ruby_version) { '2.2.3' }
          let(:ruby_engine) { 'jruby' }
          it 'does not show warning about vulnerability' do
            expect(STDERR).to_not have_received(:puts)
          end
        end
      end

      context 'with an untracked ruby' do
        context 'when the Ruby is not listed' do
          let(:ruby_version) { '1.2.3' }
          let(:ruby_engine) { 'ironruby' }
          it 'shows warning about vulnerability' do
            expect(STDERR).to have_received(:puts).with(
              /RubyDep: WARNING: your Ruby has security vulnerabilities!/)
          end
        end
      end
    end
  end
end
