module MatrixQQ
  class QQ
    SIGN = %i[
      message
      private
      group
      get_group_list
      event
      group_upload
      group_admin
      group_decrease
      group_increase
      friend_add
      friend_request
      join_request
      invite_request
      all
      unknow
    ].freeze

    class << self
      SIGN.each { |i| attr_accessor i }
    end
    SIGN.each { |i| QQ.send (i.to_s + '='), [] }

    CQ = {
      'text'   => ->(msg) { msg['data']['text'] },
      'face'   => ->(msg) { "[QQ 表情:#{msg['data']['id']}]" },
      'bface'  => ->(msg) { "[QQ 原创表情:#{msg['data']['id']}]" },
      'sface'  => ->(msg) { "[QQ 小表情:#{msg['data']['id']}]" },
      'emoji'  => ->(msg) { [msg['data']['id'].to_i].pack 'U' },
      'record' => ->(___) { '[语音]' },
      'image'  => ->(msg) { msg['data']['url'] },
      'at'     => ->(msg) { "@#{msg['data']['qq']} " },
      'rps'    => ->(msg) { "[#{%w[石头 剪刀 布][msg['data']['type'] - 1]}]" },
      'dice'   => ->(msg) { "[掷得 #{msg['data']['type']} 点]" },
      'shake'  => ->(___) { '[窗口抖动]' },
      'music'  => ->(msg) { "[音乐 #{msg['data'].to_json}]" },
      'share'  => ->(msg) { "[分享 #{msg['data'].to_json}]" },
      'anonymous' => ->(___) { '[匿名消息:]' }
    }.freeze

    attr_reader :dbus, :info
    attr_accessor :matrix_dbus

    def initialize(dbus)
      @dbus = DBus.new dbus
      reg
    end

    def reg
      SIGN.each do |i|
        @dbus.obj.on_signal i.to_s do |json|
          info = JSON.parse json
          QQ.send(i).each do |func|
            MatrixQQ.log(func.name) do
              func.new(@dbus, @matrix_dbus, info.dup).run
            end
          end
        end
      end
    end

    def self.cq_call(msg)
      m = QQ::CQ[msg['type']]
      raise "Unknow type #{msg['type']}" if m.nil?
      m = m.call(msg)
      return '' if m.nil?
      m
    end
  end
end
