class TransactionalStore
  attr_accessor :history, :store

  def initialize
    @history = []
    @store = {}
  end

  def set(key, val)
    store[key] = val
  end

  def get(key)
    store[key] || 'key not set'
  end

  def delete(key)
    store.delete(key)
  end

  def count(val)
    store.count { |_, v| v == val }
  end

  def begin_transaction
    history << store.dup unless store.empty?
  end

  def commit_transaction
    return 'no transaction' if history.empty?
    history.pop
  end

  def rollback_transaction
    if history.empty?
      store.clear
    else 
      history.last.each do |key, value|
        store[key] = value
      end
    end
    history.pop
  end
end