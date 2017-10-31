module MatrixQQ
  class Matrix
    module Send
      def self.raw(dbus, room_id, event_type, body)
        txn_id = SecureRandom.hex(32)
        puts "send #{body}" if $VERBOSE
        uri = "/rooms/#{room_id}/send/#{event_type}/#{txn_id}"
        dbus.put uri, body.merge(forword: false)
      end

      def self.text(dbus, room_id, message)
        raw dbus, room_id, 'm.room.message', msgtype: 'm.text', body: message
      end
    end # Send
  end # Matrix
end
