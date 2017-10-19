module MatrixQQ
  # TODO
  class Matrix
    SIGN = %i[
      all
      account_data
      to_device
      presence
      rooms
      leave
      join
      invite
      device_lists
      changed
      left
    ].freeze

    class << self
      SIGN.each { |i| attr_accessor i }
    end
    SIGN.each { |i| Matrix.send (i.to_s + '='), [] }

    attr_reader :obj, :info

    def initialize(dbus)
      srv = dbus.service 'org.dastudio.matrix'
      @obj = srv.object '/org/dastudio/matrix'
      @obj.default_iface = 'org.dastudio.matrix'
      reg
    end

    def reg
      SIGN.each do |i|
        @obj.on_signal i.to_s do |json|
          parse json
          Matrix.send(i).each do |func|
            puts "Start #{func.name}" if $VERBOSE
            func.new(@obj, @info).run
            puts "End #{func.name}" if $VERBOSE
          end
        end
      end
    end

    private

    def parse(json)
      @info = JSON.parse json
    end
  end
end
