module MatrixQQ
  class Matrix
    class Forward
      # send to qq group
      class Group
        def initialize(dbus, matrix, info, room)
          @dbus = dbus
          @info = info
          @matrix = matrix
          @room = room
        end

        def run
          msg = @info['content']
          body = msg['body']
          type = msg['msgtype']
          sender = user @info['sender']
          sender, body = user_bot body if user_bot? body
          MatrixQQ::QQ::SendGroup.text \
            @matrix, @room, format_matrix_message(body, sender, type)
        end

        def format_matrix_message(msg, name, type = 'm.text')
          return "#{name} 发送了一条消息" if msg =~ /^-msg /
          return '有人发送了一条消息' if msg =~ /^-all /
          return if msg =~ /^- /

          info = type.match(/^m\./).post_match
          info ||= 'text'
          message msg, name, info
        end

        def message(msg, name, type)
          case type
          when 'text'
            m = msg.match(/^-name /)
            m ? m.post_match : "[#{name}] #{msg}"
          when 'notice' then "[#{name}] notice #{msg}"
          when 'emote' then "#{name} #{msg}"
          else "#{name} send a #{info}"
          end
        end

        def user(user)
          @dbus.get("/profile/#{user}/displayname")['displayname']
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
      end # Matrix

      Forward.send_to['group'] << Group
    end # ForwardGroup
  end # QQ
end
