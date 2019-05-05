require_relative 'transactional_store.rb'
class App < TransactionalStore
  NEW_LINE = $/ + '>'

  def run
    print '>'
    loop do
      input = gets.chomp
      cmd, key, val = input.split(' ')
      case cmd
      when 'SET'
        print set(key, val)
      when 'GET'
        print get(key)
      when 'DELETE'
        delete(key)
      when 'COUNT'
        print count(key)
      when 'BEGIN'
        begin_transaction
      when 'COMMIT'
        commit_transaction
      when 'ROLLBACK'
        rollback_transaction
      when 'exit'
        break
      else
        print "#{cmd} is not a valid command"
      end
      print NEW_LINE
    end
  end
end

App.new.run
