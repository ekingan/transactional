require_relative '../terminal.rb'

RSpec.describe Terminal do
  describe '#input' do
    before(:each) do
      allow(subject).to receive(:gets).and_return('SET foo 123')
      allow(subject).to receive(:loop).and_yield
    end

    it 'returns user command as the first argument' do
      expect(subject.input[0]).to eq('SET')
    end

    it 'returns key as the second argument' do
      expect(subject.input[1]).to eq('foo')
    end

    it 'returns value as the third argument' do
      expect(subject.input[2]).to eq('123')
    end
  end

  describe '#run' do
    before(:each) do
      allow(subject).to receive(:loop).and_yield
    end

    it 'returns the value when a key/value pair is set' do
      allow(subject).to receive(:input).and_return(%w[SET foo 123])
      expect { subject.run }.to output(">123\n>").to_stdout
    end

    it 'is case sensitive and requires commands be in all caps' do
      allow(subject).to receive(:input).and_return('set')
      expect { subject.run }.to output(">set is not a valid command\n>").to_stdout
    end

    it 'returns an error message when asked to delete a key not in the store' do
      allow(subject).to receive(:input).and_return(%w[DELETE foo])
      expect { subject.run }.to output(">key not found\n>").to_stdout
    end

    it 'does not accept multi-line input' do
      allow(subject).to receive(:input).and_return(%w[SET\n foo 123])
      expect { subject.run }.to output(">SET\\n is not a valid command\n>").to_stdout
    end
  end
end