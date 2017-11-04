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
          all = run_exact room, value
          run_all room, value if all
        end
      end

      def run_exact(room, value)
        tunnel = Config[:tunnel][room]
        return false if tunnel.nil?
        return false unless tunnel[:type] == 'matrix'
        each_event value['timeline']['events'], tunnel
        intercept = tunnel[:intercept]
        return true if intercept.nil?
        intercept
      end

      def run_all(room, value)
        tunnel = Config[:tunnel]['matrix']
        return false if tunnel.nil?
        return false unless tunnel[:type] == 'all'
        each_event \
          value['timeline']['events'],
          tunnel,
          print_room: true,
          send_room: room
      end

      def each_event(events, tunnel, hackin = {})
        events.each do |event|
          next unless event['type'] == 'm.room.message'
          next if exist event['content']['forword']
          event.merge!(hackin)
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

      def exist(forword)
        return false if forword.nil?
        !forword
      end
    end # Forward

    Matrix.join << Forward
  end
end
