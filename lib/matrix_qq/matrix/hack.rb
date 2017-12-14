module MatrixQQ
  class Matrix
    module Hack
      class << self
        attr_accessor :list

        Hack.list = []

        def user(dbus, user)
          dbus.get("/profile/#{user}/displayname")['displayname']
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
      end

      Hack.list << lambda do |dbus, info, i|
        return unless info.is_a? Hash
        return unless i == :join
        info.each_value.map do |events|
          events['timeline']['events'].map do |e|
            body = e['content']['body']
            next if body.nil?
            sender = Hack.user dbus, e['sender']
            sender, body = Hack.user_bot body if Hack.user_bot? body
            e['sender_name'] = sender
            e['content']['body'] = body
            e
          end
          events
        end
        info
      end
    end
  end
end
