module MatrixQQ
  class Matrix
    # send message
    module Send
      def self.send(dbus, room_id, event_type, body)
        txn_id = SecureRandom.hex(32)
        dbus.put "/rooms/#{room_id}/send/#{event_type}/#{txn_id}", body
      end
    end # Send
  end # Matrix
end
