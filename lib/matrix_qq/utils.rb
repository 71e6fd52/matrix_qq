module MatrixQQ
  class << self
    def log(name, call = nil)
      uuid = SecureRandom.uuid
      puts "Start #{name} -- #{uuid}" if $VERBOSE
      if call.nil?
        yield
      else
        call.call
      end
      puts "End #{name} -- #{uuid}" if $VERBOSE
    end
  end
end
