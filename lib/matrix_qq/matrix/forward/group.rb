module MatrixQQ
  class Matrix
    class Forward
      # send to qq group
      class Group
        Emoji = [
          *(0x0080..0x02AF),
          *(0x0300..0x03FF),
          *(0x0600..0x06FF),
          *(0x0C00..0x0C7F),
          *(0x1DC0..0x1DFF),
          *(0x1E00..0x1EFF),
          *(0x2000..0x209F),
          *(0x20D0..0x214F),
          *(0x2190..0x23FF),
          *(0x2460..0x25FF),
          *(0x2600..0x27EF),
          *(0x2900..0x29FF),
          *(0x2B00..0x2BFF),
          *(0x2C60..0x2C7F),
          *(0x2E00..0x2E7F),
          *(0x3000..0x303F),
          *(0xA490..0xA4CF),
          *(0xE000..0xF8FF),
          *(0xFE00..0xFE0F),
          *(0xFE30..0xFE4F),
          *(0x1F000..0x1F02F),
          *(0x1F0A0..0x1F0FF),
          *(0x1F100..0x1F64F),
          *(0x1F680..0x1F6FF),
          *(0x1F910..0x1F96B),
          *(0x1F980..0x1F9E0)
        ].freeze

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
          message = format_matrix_message(body, sender, type)
          MatrixQQ::QQ::SendGroup.array @matrix, @room, emoji(message)
        end

        def emoji(msg)
          return { type: 'text', data: { text: msg } } if (msg & Emoji).empty?
          msg.each_codepoint.inject([]) do |obj, code|
            obj <<
              if Emoji.include? code
                { type: 'emoji', data: { id: code.to_s } }
              else
                { type: 'text', data: { text: [code].pack('U') } }
              end
          end
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
