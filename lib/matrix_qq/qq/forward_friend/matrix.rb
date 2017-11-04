module MatrixQQ
  class QQ
    class ForwardFriend
      class Matrix
        def initialize(dbus, matrix, info, room)
          @dbus = dbus
          @info = info
          @matrix = matrix
          @room = room
        end

        def run
          msg = message @info['message']
          sender = "[#{user @info['user_id']}] " if @info['print_sender']
          MatrixQQ::Matrix::Send.text \
            @matrix, @room,
            "#{sender}#{msg}"
        end

        def message(messages)
          messages.inject('') do |obj, msg|
            obj + QQ.cq_call(msg)
          end
        end

        def user(user)
          @dbus.get_stranger_info(user_id: user)['nickname']
        end
      end # Matrix

      ForwardFriend.send_to['matrix'] << Matrix
    end # ForwardFriend
  end # QQ
end
