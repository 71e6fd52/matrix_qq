module MatrixQQ
  # TODO
  module Matrix
    def self.log_message(obj, json)
      info = JSON.parse json
      info.each_pair do |room, events|
        puts "#{room}:"
        events['timeline']['events'].each do |event|
          next unless event['type'] == 'm.room.message'
          content = event['content']
          name = obj.get "/profile/#{event['sender']}/displayname", ''
          name = JSON.parse(name[0])['displayname']
          if content['msgtype'] == 'm.text'
            message = content['body']
            m = message.match(/^(\(.*?\))?\[(.*?)\]\s*/)
            if m
              name = m[2]
              message = m.post_match
            end
            puts "#{name}: #{message}"
          else
            puts "#{name}: #{content}"
          end
        end
      end
    end
  end
end
