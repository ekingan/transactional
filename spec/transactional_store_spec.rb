require_relative '../transactional_store.rb'

RSpec.describe TransactionalStore do
  describe '#set' do
    it 'sets a key and value in the store' do
      subject.set('foo', '123')
      expect(subject.store['foo']).to eq '123'
    end
  end

  describe '#get' do
    it 'gets the value when given a key' do
      subject.set('foo', '123')
      expect(subject.get('foo')).to eq '123'
    end

    it 'returns a message if the key does not exist' do
      expect(subject.get('bar')).to eq 'key not set'
    end
  end

  describe '#delete' do
    it 'deletes a key value pair' do
      subject.set('foo', '123')
      subject.delete('foo')
      expect(subject.store['foo']).to eq nil
    end
  end

  describe '#count' do
    it 'counts how many times a value appears in the store' do
      subject.set('foo', '123')
      subject.set('bar', '123')
      subject.set('baz', '456')
      expect(subject.count('123')).to eq 2
      expect(subject.count('456')).to eq 1
    end

    it 'counts uncommited transactions' do
      subject.set('foo', '123')
      subject.set('baz', '456')
      subject.begin_transaction
      subject.set('bar', '123')
      expect(subject.count('123')).to eq 2
      expect(subject.count('456')).to eq 1
    end
  end

  describe '#begin_transaction' do
    it 'begins a new transaction' do
      subject.set('foo', '123')
      expect(subject.history.empty?).to be true
      subject.begin_transaction
      expect(subject.history.empty?).to be false
    end

    it 'does not affect transactions already in the store' do
      subject.set('foo', '123')
      subject.begin_transaction
      expect(subject.store['foo']).to eq '123'
    end
  end

  describe '#commit_transaction' do
    it 'completes the current transaction' do
      subject.begin_transaction
      subject.set('foo', '123')
      subject.commit_transaction
      expect(subject.get('foo')).to eq '123'
    end

    it 'provides a message if there is nothing to commit' do
      subject.begin_transaction
      expect(subject.commit_transaction).to eq 'no transaction'
    end
  end

  describe '#rollback_transaction' do
    it 'rolls back an uncommitted transaction' do
      subject.begin_transaction
      subject.set('b', 'baloon')
      subject.rollback_transaction
      expect(subject.get('b')).to eq 'key not set'
    end

    it 'rolls back a transaction' do
      subject.set('foo', '123')
      subject.set('bar', 'abc')
      subject.begin_transaction
      subject.set('foo', '456')
      expect(subject.get('foo')).to eq '456'
      subject.set('bar', 'def')
      expect(subject.get('bar')).to eq 'def'
      subject.rollback_transaction
      expect(subject.get('foo')).to eq '123'
      subject.rollback_transaction
      expect(subject.get('a')).to eq 'key not set'
      expect(subject.commit_transaction).to eq 'no transaction'
    end

    it 'rolls back nested transactions' do
      subject.set('foo', '123')
      subject.begin_transaction
      subject.set('foo', '456')
      subject.begin_transaction
      subject.set('foo', '789')
      expect(subject.get('foo')).to eq '789'
      subject.rollback_transaction
      expect(subject.get('foo')).to eq '456'
      subject.rollback_transaction
      expect(subject.get('foo')).to eq '123'
    end

    it 'does not affect items already set' do
      subject.set('a', 'apple')
      subject.begin_transaction
      subject.set('b', 'baloon')
      subject.rollback_transaction
      expect(subject.get('a')).to eq 'apple'
      expect(subject.get('b')).to eq 'key not set'
    end
  end
end

