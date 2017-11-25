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
          sender = @info['sender_name']
          message = format_matrix_message(body, sender, type)
          MatrixQQ::QQ::SendGroup.text @matrix, @room, message
        end

        def format_matrix_message(msg, name, type = 'm.text')
          room = "{#{@info['send_room']}} " if @info['print_room']
          return "#{room}#{name} 发送了一条消息" if msg =~ /^-msg /
          return '有人发送了一条消息' if msg =~ /^-all /
          return if msg =~ /^- /

          info = type.match(/^m\./).post_match
          info ||= 'text'
          message msg, name, info, room
        end

        def message(msg, name, type, room = '')
          case type
          when 'text'
            m = msg.match(/^-name /)
            m ? m.post_match : "#{room}[#{name}] #{msg}"
          when 'notice' then "#{room}[#{name}] notice #{msg}"
          when 'emote' then "#{room}#{name} #{msg}"
          else "#{room}#{name} send a #{type}"
          end
        end
      end # Matrix

      Forward.send_to['group'] << Group
    end # ForwardGroup
  end # QQ
end
