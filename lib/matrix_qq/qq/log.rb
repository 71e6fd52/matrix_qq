module MatrixQQ
  class QQ
    # Log message
    class Log
      def initialize(dbus, _, info)
        @dbus = dbus
        @info = info
      end

      def run
        return unless @info.is_a? Hash
        log_room @info['group_id'] if @info.key? 'group_id'
        msg = message @info['message']
        sender = user @info['user_id'], @info['group_id']
        log_message sender, msg
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

      def log_message(name, message)
        puts "#{name}: #{message}"
      end

      def log_room(groupid)
        puts "#{room(groupid)}:"
      end

      def room(groupid)
        groupid
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
    end # Log

    QQ.message << Log
  end
end
