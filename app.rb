@transaction = {}
@temp = []
NEW_LINE = $/ + '>'

def set(key, val)
  @transaction[key] = val
  print @transaction[key] + NEW_LINE
end

def get(key)
  if @transaction[key]
    print @transaction[key] + NEW_LINE
  else
    print 'key not set' + NEW_LINE
  end
end

def delete(key)
  @transaction.tap{ |x| x.delete(key) }
  print NEW_LINE
end

def count(val)
  count = @transaction.count { |_, v| v == val }
  print count.to_s + NEW_LINE
end

def begin_transaction
  unless defined?(@store)
    @store = @transaction # store the key values we already have
  end
  @temp << @transaction
  @transaction = {}
  print NEW_LINE
end

def commit_transaction
  if @transaction == @store
    print 'no transactions' + NEW_LINE
  else
    @transaction = @store.merge!(@transaction)
    print NEW_LINE
  end
end

def rollback_transaction
  @transaction = @temp.last
  @temp.pop
  print NEW_LINE
end

print '>'
loop do
  input = gets.chomp
  cmd, key, val = input.split(' ')
  case cmd
  when 'SET'
    set(key, val)
  when 'GET'
    get(key)
  when 'DELETE'
    delete(key)
  when 'COUNT'
    count(key)
  when 'BEGIN'
    begin_transaction
  when 'COMMIT'
    commit_transaction
  when 'ROLLBACK'
    rollback_transaction
  when 'exit'
    break
  else
    print "#{cmd} is not a valid command" + NEW_LINE
  end
end
