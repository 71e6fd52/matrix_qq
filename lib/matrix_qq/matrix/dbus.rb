module MatrixQQ
  class Matrix
    # matrix D-Bus wrapper
    class DBus
      attr_reader :obj

      def initialize(dbus)
        srv = dbus.service('org.dastudio.matrix')
        @obj = srv.object '/org/dastudio/matrix'
        @obj.default_iface = 'org.dastudio.matrix'
      end

      def respond_to_missing?(name, include_private = false)
        @obj.respond_to_missing? name, include_private
      end

      def method_missing(name, *args)
        super if args.size > 2
        args << {} if args.size == 1
        JSON.parse @obj.send(name, args[0], args[1].to_json).first
      end
    end
  end
end
