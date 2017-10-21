module MatrixQQ
  class QQ
    # QQ D-Bus wrapper
    class DBus
      attr_reader :obj

      def initialize(dbus)
        srv = dbus.service('org.dastudio.qq')
        @obj = srv.object '/org/dastudio/qq'
        @obj.default_iface = 'org.dastudio.cqhttp'
      end

      def respond_to_missing?(name, include_private = false)
        @obj.respond_to_missing? name, include_private
      end

      def method_missing(name, *args)
        super if args.size > 1
        args << {} if args.empty?
        arg = args.first
        JSON.parse @obj.call(name.to_s, arg.to_json).first
      end
    end
  end
end
