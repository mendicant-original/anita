module Anita
  class Message
    attr_reader :text, :usernick, :channel

    def initialize(m)
      @text     = m.message
      @usernick = m.user.nick
      @channel  = m.channel
    end
  end
end
