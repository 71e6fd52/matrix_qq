module MatrixQQ
  class QQ
    module SendGroup
      def self.raw(dbus, room_id, body)
        dbus.send_group_msg group_id: room_id, message: body
      end

      def self.text(dbus, room_id, message)
        return if message.nil?
        raw dbus, room_id, [message]
      end
    end # Send
  end # Matrix
end
