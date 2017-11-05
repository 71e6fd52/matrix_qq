module MatrixQQ
  class QQ
    class AgreeFriend
      def initialize(dbus, _, info)
        @dbus = dbus
        @info = info
      end

      def run
        return unless @info.is_a? Hash
        @dbus.set_friend_add_request flag: @info['flag']
      end
    end # AgreeFriend

    class AgreeGroup
      def initialize(dbus, _, info)
        @dbus = dbus
        @info = info
      end

      def run
        return unless @info.is_a? Hash
        @dbus.set_group_add_request flag: @info['flag'], type: 'invite'
      end
    end # AgreeGroup

    QQ.friend_request << AgreeFriend
    QQ.invite_request << AgreeGroup
  end
end
