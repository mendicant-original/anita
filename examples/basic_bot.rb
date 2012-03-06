require_relative "../lib/anita"

module EchoPlugin
  def self.process(message)
    "::ECHO:: #{message.text}"
  end

  def self.usage
    "type any message to have it echoed"
  end
end

Anita::Bot.configure do |bot|
  bot.server   = "irc.freenode.org"
  bot.channels = ["#anita-bots"]
end

Anita::Bot.assimilate(EchoPlugin)

Anita::Bot.start
