module MatrixQQ
  class Matrix
    # Log message
    class Log
      def initialize(obj, info)
        @obj = obj
        @info = info
      end

      def run
        return unless @info.is_a? Hash
        @info.each_pair do |room, events|
          log_room room
          events['timeline']['events'].each do |event|
            next unless event['type'] == 'm.room.message'
            log_message event['sender'], event['content']
          end
        end
      end

      def log_message(sender, content)
        name = user sender
        if content['msgtype'] == 'm.text'
          message = content['body']
          name, message = user_bot message if user_bot? message
        else
          message = content
        end
        puts "#{name}: #{message}"
      end

      def log_room(room)
        puts "#{self.room(room)['name']}:"
      end

      def room(room)
        JSON.parse @obj.get("/rooms/#{room}/state/m.room.name", '').first
      end

      def user(user)
        name = JSON.parse @obj.get("/profile/#{user}/displayname", '').first
        name['displayname']
      end

      def match_bot(message)
        message.match(/^(\(.*?\))?\[(.*?)\]\s*/)
      end

      def user_bot?(message)
        m = match_bot message
        return true if m
        false
      end

      def user_bot(message)
        m = match_bot message
        return unless m
        [m[2], m.post_match]
      end
    end # Log

    Matrix.join << Log
  end # Matrix
end
