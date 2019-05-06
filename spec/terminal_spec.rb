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
end
