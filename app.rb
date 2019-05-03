@store = Hash.new
NEW_LINE = $/ + ">"

def set(key, val)
  @store[key] = val
  print @store[key] + NEW_LINE
end

def get(key)
  print 'key not set' + NEW_LINE  unless @store[key]
  print @store[key] + NEW_LINE
end

def delete(key)
  puts key
  puts @store
  @store.delete(:key)
  print "Deleted #{key}" + NEW_LINE
end

def count(val)
  count = @store.count { |_, v| v == val }
  print count + NEW_LINE
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
      delete(key)
    when 'BEGIN'
      
    when "exit"
      break
  end
end
