module MatrixQQ
  class Matrix
    module Send
      class << self
        attr_accessor :ignore, :ignore_lock
      end
      self.ignore = []
      self.ignore_lock = Concurrent::ReadWriteLock.new

      def self.raw(dbus, room_id, event_type, body)
        Thread.new do
          ignore_lock.with_write_lock do
            txn_id = SecureRandom.hex(32)
            puts "send #{body}" if $VERBOSE
            uri = "/rooms/#{room_id}/send/#{event_type}/#{txn_id}"
            res = dbus.put uri, body
            ignore << (res['event_id'])
          end
        end
      end

      def self.text(dbus, room_id, message)
        raw dbus, room_id, 'm.room.message', msgtype: 'm.text', body: message
      end
    end # Send
  end # Matrix
end
