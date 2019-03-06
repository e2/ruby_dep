require 'ruby_dep/ruby_version'

RSpec.describe RubyDep::RubyVersion do
  describe '#version' do
    subject { described_class.new('2.3.0', 'jruby') }
    specify { expect(subject.version).to be_a(Gem::Version) }
    specify { expect(subject.version).to eq(Gem::Version.new('2.3.0')) }
  end

  describe '#engine' do
    subject { described_class.new('2.3.0', 'jruby') }
    specify { expect(subject.engine).to eq('jruby') }
  end

  describe '#recognized?' do
    context 'with an untracked ruby' do
      subject { described_class.new('1.2.3', 'ironruby') }
      specify { expect(subject).to_not be_recognized }
    end

    context 'with ruby' do
      subject { described_class.new('2.0.0', 'ruby') }
      specify { expect(subject).to be_recognized }
    end

    context 'with jruby' do
      subject { described_class.new('2.3.0', 'jruby') }
      specify { expect(subject).to be_recognized }
    end

    context 'with truffleruby 1.0.0-rc2' do
      subject { described_class.new('2.4.4', 'truffleruby') }
      specify { expect(subject).to be_recognized }
    end

    context 'with a recent truffleruby' do
      subject { described_class.new('2.6.1', 'truffleruby') }
      specify { expect(subject).to be_recognized }
    end
  end

  describe '#status' do
    context 'with an untracked ruby' do
      subject { described_class.new('1.2.3', 'ironruby') }
      specify { expect(subject.status).to eq(:untracked) }
    end

    context 'with a base ruby' do
      subject { described_class.new('2.0.0', 'ruby') }
      specify { expect(subject.status).to eq(:insecure) }
    end

    context 'with a latest ruby' do
      subject { described_class.new('2.3.1', 'ruby') }
      specify { expect(subject.status).to eq(:unknown) }
    end

    context 'with a buggy ruby' do
      subject { described_class.new('2.3.0', 'ruby') }
      specify { expect(subject.status).to eq(:buggy) }
    end

    context 'with an unsupported ruby' do
      subject { described_class.new('1.9.2', 'ruby') }
      specify { expect(subject.status).to eq(:insecure) }
    end

    context 'with a future ruby' do
      subject { described_class.new('9.8.7', 'ruby') }
      specify { expect(subject.status).to eq(:unknown) }
    end

    context 'with truffleruby 1.0.0-rc2' do
      subject { described_class.new('2.4.4', 'truffleruby') }
      specify { expect(subject.status).to eq(:unknown) }
    end

    context 'with a recent truffleruby' do
      subject { described_class.new('2.6.1', 'truffleruby') }
      specify { expect(subject.status).to eq(:unknown) }
    end
  end
end
