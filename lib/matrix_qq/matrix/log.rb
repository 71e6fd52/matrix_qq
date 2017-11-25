module MatrixQQ
  class Matrix
    # Log message to stdout
    class Log
      def initialize(dbus, _, info)
        @dbus = dbus
        @info = info
      end

      def run
        return unless @info.is_a? Hash
        @info.each_pair do |room, events|
          log_room room
          events['timeline']['events'].each do |event|
            next unless event['type'] == 'm.room.message'
            log_message event['sender_name'], event['content']
          end
        end
      end

      def log_message(sender, content)
        message = content['msgtype'] == 'm.text' ? content['body'] : content
        puts "#{sender}: #{message}"
      end

      def log_room(room)
        puts "#{self.room(room)['name']}:"
      end

      def room(room)
        @dbus.get "/rooms/#{room}/state/m.room.name"
      end
    end # Log

    Matrix.join << Log
  end # Matrix
end
