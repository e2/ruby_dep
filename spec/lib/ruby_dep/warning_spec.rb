require 'ruby_dep/warning'

RSpec.describe RubyDep::Warning do
  let(:logger) { instance_double(RubyDep::Logger) }

  let(:outdated_ruby) { instance_double(RubyDep::RubyVersion) }
  let(:up_to_date_ruby) { instance_double(RubyDep::RubyVersion) }
  let(:buggy_ruby) { instance_double(RubyDep::RubyVersion) }
  let(:insecure_ruby) { instance_double(RubyDep::RubyVersion) }
  let(:unsupported_ruby) { instance_double(RubyDep::RubyVersion) }
  let(:untracked_engine_ruby) { instance_double(RubyDep::RubyVersion) }

  before do
    allow(RubyDep::Logger).to receive(:new)
      .with(STDERR, 'RubyDep: WARNING: ').and_return(logger)
    allow(logger).to receive(:warning)
    allow(logger).to receive(:notice)

    allow(RubyDep::RubyVersion).to receive(:new)
      .with(RUBY_VERSION, RUBY_ENGINE).and_return(ruby_version)

    allow(up_to_date_ruby).to receive(:version)
      .and_return(Gem::Version.new('2.3.1'))
    allow(up_to_date_ruby).to receive(:status).and_return(:unknown)

    allow(buggy_ruby).to receive(:version)
      .and_return(Gem::Version.new('2.2.4'))
    allow(buggy_ruby).to receive(:status).and_return(:buggy)
    allow(buggy_ruby).to receive(:recognized?).and_return(true)
    allow(buggy_ruby).to receive(:recommended)
      .with(:unknown).and_return(['2.2.5', '2.3.1'])

    allow(insecure_ruby).to receive(:version)
      .and_return(Gem::Version.new('2.2.3'))
    allow(insecure_ruby).to receive(:status).and_return(:insecure)
    allow(insecure_ruby).to receive(:recognized?).and_return(true)
    allow(insecure_ruby).to receive(:recommended)
      .with(:unknown).and_return(['2.2.5', '2.3.1'])
    allow(insecure_ruby).to receive(:recommended)
      .with(:buggy).and_return(['2.2.4', '2.3.0'])

    allow(unsupported_ruby).to receive(:version)
      .and_return(Gem::Version.new('1.9.3'))
    allow(unsupported_ruby).to receive(:status).and_return(:insecure)
    allow(unsupported_ruby).to receive(:recognized?).and_return(true)
    allow(unsupported_ruby).to receive(:recommended)
      .with(:unknown).and_return(['2.2.5', '2.3.1'])
    allow(unsupported_ruby).to receive(:recommended)
      .with(:buggy).and_return(['2.1.9', '2.2.4', '2.3.0'])

    allow(untracked_engine_ruby).to receive(:version)
      .and_return(Gem::Version.new('1.2.3'))
    allow(untracked_engine_ruby).to receive(:status).and_return(:untracked)
    allow(untracked_engine_ruby).to receive(:recognized?).and_return(false)
    allow(untracked_engine_ruby).to receive(:engine).and_return('ironruby')
  end

  def rquote(str)
    Regexp.new(Regexp.quote(str))
  end

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
        let(:ruby_version) { outdated_ruby }
        it 'does not show anything' do
          expect(logger).to_not have_received(:warning)
          expect(logger).to_not have_received(:notice)
        end
      end
    end

    context 'when not silenced' do
      context 'with an up-to-date Ruby' do
        let(:ruby_version) { up_to_date_ruby }
        it 'does not show anything' do
          expect(logger).to_not have_received(:warning)
          expect(logger).to_not have_received(:notice)
        end
      end

      context 'with a secure but buggy Ruby' do
        let(:ruby_version) { buggy_ruby }
        it 'shows warning about bugs' do
          expect(logger).to have_received(:warning).with(
            %r{Your Ruby is outdated\/buggy.})
        end

        it 'shows recommended action' do
          expected = rquote(
            'Your Ruby is: 2.2.4 (buggy). Recommendation: upgrade to'\
            ' 2.2.5 or 2.3.1')
          expect(logger).to have_received(:notice).with(expected)
        end
      end

      context 'with an insecure Ruby' do
        let(:ruby_version) { insecure_ruby }
        it 'shows warning about vulnerability' do
          expect(logger).to have_received(:warning).with(
            /Your Ruby has security vulnerabilities!/)
        end

        it 'shows recommended action' do
          expected = rquote(
            'Your Ruby is: 2.2.3 (insecure). Recommendation:'\
            ' upgrade to 2.2.5 or 2.3.1. (Or, at least to 2.2.4 or 2.3.0)')
          expect(logger).to have_received(:notice).with(expected)
        end
      end

      context 'with an unsupported Ruby' do
        let(:ruby_version) { unsupported_ruby }
        it 'shows warning about vulnerability' do
          expect(logger).to have_received(:warning).with(
            /Your Ruby has security vulnerabilities!/)
        end

        it 'shows recommended action' do
          expected = rquote(
            'Your Ruby is: 1.9.3 (insecure). Recommendation: upgrade to 2.2.5'\
            ' or 2.3.1. (Or, at least to 2.1.9 or 2.2.4 or 2.3.0)')
          expect(logger).to have_received(:notice).with(expected)
        end
      end

      context 'with an untracked ruby engine' do
        context 'when the Ruby is not listed' do
          let(:ruby_version) { untracked_engine_ruby }
          it 'shows warning about lack of support' do
            expect(logger).to have_received(:warning).with(
              /Your Ruby may not be supported./)
          end

          it 'shows recommended action' do
            expected = rquote(
              "Your Ruby is: 1.2.3 'ironruby' (unrecognized). If you need"\
              ' this version supported, please open an issue at'\
              ' http://github.com/e2/ruby_dep')
            expect(logger).to have_received(:notice).with(expected)
          end
        end
      end
    end
  end
end
