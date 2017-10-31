module MatrixQQ
  class QQ
    SIGN = %i[
      message
      private
      group
      get_group_list
      event
      group_upload
      group_admin
      group_decrease
      group_increase
      friend_add
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
          info = JSON.parse json
          QQ.send(i).each do |func|
            MatrixQQ.log(func.name) do
              func.new(@dbus, @matrix_dbus, info.dup).run
            end
          end
        end
      end
    end
  end
end
