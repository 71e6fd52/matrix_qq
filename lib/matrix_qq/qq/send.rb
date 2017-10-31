module MatrixQQ
  class QQ
    module SendGroup
      def self.raw(dbus, room_id, body)
        dbus.send_group_msg group_id: room_id, message: body
      end

      def self.array(dbus, room_id, message)
        return if message.nil?
        return unless message.is_a? Array
        return if message.empty?
        raw dbus, room_id, message
      end

      def self.text(dbus, room_id, message)
        return if message.nil?
        return unless message.is_a? String
        raw dbus, room_id, message
      end
    end # Send
  end # Matrix
end
