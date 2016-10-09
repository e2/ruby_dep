require 'ruby_dep/travis'

RSpec.describe RubyDep::Travis::RubyVersion do
  subject { described_class.new(travis_version_string) }

  describe '#initialize' do
    context 'with an unknown version string' do
      let(:travis_version_string) { 'ruby-head' }
      it 'returns the version segments' do
        expect { subject }.to raise_error(
          described_class::Error::Unrecognized,
          /Unrecognized Ruby version: "ruby-head"/
        )
      end
    end

    context 'with an unhandled JRuby version string' do
      let(:travis_version_string) { 'jruby-9.9.9.9' }
      it 'returns the version segments' do
        expect { subject }.to raise_error(
          described_class::Error::Unrecognized::JRubyVersion,
          /Unrecognized JRuby version: "9.9.9.9"/
        )
      end
    end
  end

  describe '#segments' do
    context 'with a bare version string' do
      let(:travis_version_string) { '2.2.4' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 2, 4])
      end
    end

    context 'with a ruby version string' do
      let(:travis_version_string) { 'ruby-2.2.4' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 2, 4])
      end
    end

    context 'with a ruby version string' do
      let(:travis_version_string) { 'ruby-2.2.4' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 2, 4])
      end
    end

    context 'with JRuby 9.0.4.0' do
      let(:travis_version_string) { 'jruby-9.0.4.0' }
      it 'returns the Ruby implementation version segments' do
        expect(subject.segments).to eq([2, 2, 2])
      end
    end

    context 'with JRuby 9.0.5.0' do
      let(:travis_version_string) { 'jruby-9.0.5.0' }
      it 'returns the Ruby implementation version segments' do
        expect(subject.segments).to eq([2, 2, 3])
      end
    end

    context 'with a patch-level ruby string' do
      let(:travis_version_string) { 'ruby-2.0.0-p648' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 0, 0])
      end
    end

    context 'with a clang ruby string' do
      let(:travis_version_string) { 'ruby-2.1.10-clang' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 1, 10])
      end
    end

    context 'with a patch-level clang ruby string' do
      let(:travis_version_string) { 'ruby-2.1.9-p123-clang' }
      it 'returns the version segments' do
        expect(subject.segments).to eq([2, 1, 9])
      end
    end

    context 'with JRuby 9.1.2.0' do
      let(:travis_version_string) { 'jruby-9.1.2.0' }
      it 'returns the Ruby implementation version segments' do
        expect(subject.segments).to eq([2, 3, 0])
      end
    end
  end
end
