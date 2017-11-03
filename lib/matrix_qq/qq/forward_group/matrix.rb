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
            obj + case msg['type']
                  when 'at'
                    "@#{user msg['data']['qq'], @info['group_id']} "
                  else QQ.cq_call msg
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

        def matrix_send_image(uri)
          mxc = @matrix.upload_file uri
          w, h = FastImage.size uri
          open(uri) do |f|
            gen_image_json(f.content_type, uri, mxc, w, h, f.size)
          end
        end

        def gen_image_json(type, uri, w, h, size)
          {
            body: type,
            msgtype: 'm.image',
            url: uri,
            info: { w: w, h: h, mimetype: type, size: size }
          }.to_json
        end
      end # Matrix

      ForwardGroup.send_to['matrix'] << Matrix
    end # ForwardGroup
  end # QQ
end
