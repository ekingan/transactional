class TransactionalStore
  attr_accessor :transaction, :pending, :store

  def initialize
    @transaction = {}
    @pending = []
    @store = {}
  end

  def set(key, val)
    transaction[key] = val
    transaction[key]
  end

  def get(key)
    transaction[key] || 'key not set'
  end

  def delete(key)
    transaction.tap{ |x| x.delete(key) }
  end

  def count(val)
    transaction.count { |_, v| v == val }
  end

  def begin_transaction
    save unless transaction.empty? || @saved
    set_pending
  end

  def commit_transaction
    if pending.last == store
      'no transaction'
    elsif @saved
      store.merge!(transaction)
    end
  end

  def rollback_transaction
    if pending.size == 1
      revert_to_previous(transaction, store)
    else
      revert_to_previous(transaction, pending.last)
      pending.pop
    end
  end

  def save
    @saved = true
    transaction.each do |key, value|
      store[key] = value
    end
    transaction
  end

  def revert_to_previous(to, from)
    to.clear
    from.each do |key, value|
      to[key] = value
    end
  end

  def set_pending
    pending << transaction.clone
    transaction.clear
  end
end