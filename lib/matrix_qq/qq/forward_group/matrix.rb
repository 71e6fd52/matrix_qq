module MatrixQQ
  class QQ
    class ForwardGroup
      # send to matrix
      class Matrix
        def initialize(dbus, matrix, info, room)
          @dbus = dbus
          @info = info
          @matrix = matrix
          @room = room
        end

        def run
          msg = message @info['message']
          sender = user @info['user_id'], @info['group_id']
          MatrixQQ::Matrix::Send.text @matrix, @room, "[#{sender}] #{msg}"
        end

        def message(messages)
          messages.inject('') do |obj, msg|
            obj +
              case msg['type']
              when 'text' then msg['data']['text']
              when 'emoji' then [msg['data']['id'].to_i].pack 'U'
              when 'face' then "[QQ 表情:#{msg['data']['id']}]"
              when 'record' then '[语音]'
              when 'image' then msg['data']['url']
              end
          end
        end

        def user(user, group_id = nil)
          if group_id.nil?
            return @dbus.get_stranger_info(user_id: user)['nickname']
          end
          info = @dbus.get_group_member_info(user_id: user, group_id: group_id)
          info = info['data']
          name = info['card']
          name == '' ? info['nickname'] : name
        end
      end # Matrix

      ForwardGroup.send_to['matrix'] << Matrix
    end # ForwardGroup
  end # QQ
end
