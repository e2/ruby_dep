require 'gem_isolator'

RSpec.describe 'warnings' do
  let(:gems) { [['ruby_dep', { path: Dir.pwd }]] }

  let!(:spec_path) do
    File.expand_path("spec/acceptance/fixtures/#{spec}")
  end

  let(:subcmd) do
    "bundle exec ruby #{spec_path} 2>&1"
  end

  let(:code) do
    "o=`#{subcmd}`"\
      ";raise \"Unexpected output: \#{o.inspect}\" unless o.empty?"
  end

  let(:cmd) do
    "ruby -e '#{code}'"
  end

  def run_isolated(cmd)
    GemIsolator.isolate(gems: gems) do |env, isolation|
      new_env = env.dup
      yield(new_env, isolation) if block_given?
      unless isolation.system(env, 'gem install -q bundler')
        raise 'failed to install bundler'
      end
      expect(isolation.system(new_env, cmd)).to eq(true)
    end
  end

  context 'when not silenced' do
    let!(:spec) { 'show_warnings.rb' }

    let(:code) do
      "o=`#{subcmd}`;"\
        "unless o =~ /Ruby has security vulnerabilities/\n"\
        "  raise \"Warning expected, got: \#{o.inspect}\"\n"\
        'end'
    end

    it 'produces a warning' do
      run_isolated(cmd)
    end
  end

  context 'when silenced' do
    context 'with environment variable' do
      let!(:spec) { 'show_warnings.rb' }

      it 'produces no output' do
        run_isolated(cmd) do |env, _isolation|
          env['RUBY_DEP_GEM_SILENCE_WARNINGS'] = '1'
        end
      end
    end

    context 'with special include file' do
      let!(:spec) { 'warnings_silenced_by_require.rb' }

      it 'produces no output' do
        run_isolated(cmd)
      end
    end
  end
end
