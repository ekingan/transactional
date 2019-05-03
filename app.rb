@transaction = {}
NEW_LINE = $/ + ">"

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
  @transaction.tap{|x| x.delete(key)}
  print "Deleted #{key}" + NEW_LINE
end

def count(val)
  count = @transaction.count { |_, v| v == val }
  print count.to_s + NEW_LINE
end

def start
  @store = @transaction #store the key values we already have
  @transaction = {}
  NEW_LINE
end

def get_transaction(key)
  print 'key not set' + NEW_LINE  unless @transaction[key]
  print @transaction[key] + NEW_LINE
end

def commit
  @transaction.merge!(@store)
  @transaction = {}
end

def rollback
  @transaction = @store
end

print '>'
loop do
  input = gets.chomp
  cmd, key, val = input.split(' ')
  case cmd
    when 'SET'
      set(key, val)
    when 'GET'
      @transaction.empty? ? get(key) : get_transaction(key)
    when 'DELETE'
      delete(key)
    when 'COUNT'
      count(key)
    when 'BEGIN'
      start
    when 'COMMIT'
      commit
    when 'ROLLBACK'
      rollback
    when "exit"
      break
    else 
      "#{cmd} is not a valid command"
  end
end
