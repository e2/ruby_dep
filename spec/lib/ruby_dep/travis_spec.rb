require 'ruby_dep/travis'
RSpec.describe RubyDep::Travis do
  describe '#version_constraint' do
    before do
      allow(IO).to receive(:read).with('.travis.yml').and_return(yml)
    end

    context 'with a single ruby version' do
      let(:yml) { YAML.dump('rvm' => %w(2.2.4)) }
      it 'pessimistically locks with intial supported version' do
        expect(subject.version_constraint).to eq(['~> 2.2', '>= 2.2.4'])
      end
    end

    context 'with multiple versions' do
      context 'with same major' do
        context 'with same minors' do
          context 'with different patch levels' do
            let(:yml) { YAML.dump('rvm' => %w(2.2.4 2.2.8)) }
            it 'pessimistically locks to lowest patchlevel' do
              expect(subject.version_constraint).to eq(['~> 2.2', '>= 2.2.4'])
            end
          end
        end
        context 'with different minors' do
          context 'with close minors' do
            let(:yml) { YAML.dump('rvm' => %w(2.2.4 2.1.0 2.0.3)) }
            it 'pessimistically locks to lowest version' do
              expect(subject.version_constraint).to eq(['~> 2.0', '>= 2.0.3'])
            end
          end
          context 'with gaps in minors' do
            let(:yml) { YAML.dump('rvm' => %w(2.3.0 2.2.8 2.2.4 2.0.0)) }
            it 'pessimistically locks until gap in minor' do
              expect(subject.version_constraint).to eq(['~> 2.2', '>= 2.2.4'])
            end
          end

          context 'with no gaps in minors' do
            let(:yml) { YAML.dump('rvm' => %w(2.3.0 2.2.8 2.2.4 2.1.1 2.0.1)) }
            it 'pessimistically locks until gap in minor' do
              expect(subject.version_constraint).to eq(['~> 2.0', '>= 2.0.1'])
            end
          end
        end
      end

      context 'with different majors' do
        let(:yml) { YAML.dump('rvm' => %w(2.2.4 1.9.3)) }
        it 'pessimistically locks to highest major' do
          expect(subject.version_constraint).to eq(['~> 2.2', '>= 2.2.4'])
        end
      end
    end
  end
end
