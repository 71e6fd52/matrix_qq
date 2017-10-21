module MatrixQQ
  # TODO
  class QQ
    SIGN = %i[
      message
      event
      friend_request
      join_request
      invite_request
      all
      unknow
    ].freeze

    class << self
      SIGN.each { |i| attr_accessor i }
    end
    SIGN.each { |i| QQ.send (i.to_s + '='), [] }

    attr_reader :dbus, :info
    attr_accessor :matrix_dbus

    def initialize(dbus)
      @dbus = DBus.new dbus
      reg
    end

    def reg
      SIGN.each do |i|
        @dbus.obj.on_signal i.to_s do |json|
          parse json
          QQ.send(i).each do |func|
            puts "Start #{func.name}" if $VERBOSE
            func.new(@dbus, @matrix_dbus, @info).run
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
