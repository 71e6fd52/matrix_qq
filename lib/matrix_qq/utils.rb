module MatrixQQ
  class << self
    def intercept?(tunnel)
      i = tunnel[:intercept]
      return true if i.nil?
      return true if i
      false
    end

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
