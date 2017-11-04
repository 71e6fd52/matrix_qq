module MatrixQQ
  class QQ
    class ForwardFriend
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
        return if run_exact
        run_all
      end

      def run_exact
        tunnel = Config[:tunnel][@info['user_id'].to_s]
        return false if tunnel.nil?
        return false unless tunnel[:type] == 'friend'
        tunnel[:to].each_pair do |room, type|
          call_module room, type
        end
        MatrixQQ.intercept? tunnel
      end

      def run_all
        tunnel = Config[:tunnel]['friend']
        return if tunnel.nil?
        return unless tunnel[:type] == 'all'
        tunnel[:to].each_pair do |room, type|
          call_module room, type, 'print_sender' => true
        end
      end

      def call_module(room, type, hackin = {})
        info = @info.merge hackin
        ForwardFriend.send_to[type.to_s].each do |func|
          puts "Start #{func.name}" if $VERBOSE
          func.new(@dbus, @matrix, info, room).run
          puts "End #{func.name}" if $VERBOSE
        end
      end
    end # ForwardFriend

    QQ.private << ForwardFriend
  end
end
