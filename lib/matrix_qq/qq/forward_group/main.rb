module MatrixQQ
  class QQ
    # send group massage to matrix
    class ForwardGroup
      class << self
        attr_accessor :send_to
      end
      self.send_to = Hash.new { |h, k| h[k] = [] }

      def initialize(dbus, matrix, info)
        @dbus = dbus
        @info = info
        @matrix = matrix
      end

      def run
        return unless @info.is_a? Hash
        tunnel = Config[:tunnel][@info['group_id'].to_s]
        return if tunnel.nil?
        return unless tunnel[:type] == 'group'
        tunnel[:to].each_pair do |room, type|
          call_module(room, type)
        end
      end

      def call_module(room, type)
        ForwardGroup.send_to[type.to_s].each do |func|
          puts "Start #{func.name}" if $VERBOSE
          func.new(@dbus, @matrix, @info, room).run
          puts "End #{func.name}" if $VERBOSE
        end
      end
    end # Forward

    QQ.group << ForwardGroup
  end
end
