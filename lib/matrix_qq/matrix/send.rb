module MatrixQQ
  class Matrix
    module Send
      class << self
        attr_accessor :ignore
      end
      self.ignore = []

      def self.raw(dbus, room_id, event_type, body)
        txn_id = SecureRandom.hex(32)
        res = dbus.put "/rooms/#{room_id}/send/#{event_type}/#{txn_id}", body
        ignore << JSON.parse(res)['event_id']
      end

      def self.text(dbus, room_id, message)
        raw dbus, room_id, 'm.room.message', msgtype: 'm.text', body: message
      end
    end # Send
  end # Matrix
end
