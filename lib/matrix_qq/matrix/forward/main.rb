module MatrixQQ
  class Matrix
    # send matrix massage to other
    class Forward
      class << self
        attr_accessor :send_to
      end
      self.send_to = Hash.new { |h, k| h[k] = [] }

      def initialize(dbus, qq, info)
        @dbus = dbus
        @info = info
        @qq = qq
      end

      def run
        return unless @info.is_a? Hash
        @info.each_pair do |room, value|
          tunnel = Config[:tunnel][room]
          next if tunnel.nil?
          next unless tunnel[:type] == 'matrix'
          each_event value['timeline']['events'], tunnel
        end
      end

      def each_event(events, tunnel)
        events.each do |event|
          next unless event['type'] == 'm.room.message'
          next if exist @info['event_id']
          tunnel[:to].each_pair do |to_room, type|
            call_module(event, to_room, type)
          end
        end
      end

      def call_module(event, room, type)
        Forward.send_to[type.to_s].each do |func|
          puts "Start #{func.name}" if $VERBOSE
          func.new(@dbus, @qq, event, room).run
          puts "End #{func.name}" if $VERBOSE
        end
      end

      def exist(event_id)
        MatrixQQ::Matrix::Send.ignore.delete(event_id)
      end
    end # Forward

    Matrix.join << Forward
  end
end
