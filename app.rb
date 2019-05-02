class Store
  @store = Hash.new
  
  def set(key, val)
    @store['key'] = val
  end
  
  def get(key)
    print @store['key']
  end
  
  
  loop do
    input = gets.chomp
    cmd, key, val = input.split(' ')
    case cmd
      when 'SET'
        set(key, val)
      when 'GET'
        get(key)
      when "exit"
        break
    end
  end
end