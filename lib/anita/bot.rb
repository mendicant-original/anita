module Anita
  Bot = Object.new

  class << Bot
    def assimilate(plugin)
      plugins[plugin.name] = plugin
    end

    def configure
      bot.configure{|c| yield(c)}
    end

    def start
      setup_basic_responder
      setup_usage_responder
      setup_plugins_responder

      bot.start
    end

    def bot
      @bot ||= Cinch::Bot.new{configure{|c| c.nick = "anitabot"}}
    end

    def plugins
      @plugins ||= {}
    end

    private

    def setup_basic_responder
      bot.on(:message) do |m|
        message = Anita::Message.new(m)
        Anita::Bot.plugins.each_value do |plugin|
          response = plugin.process(message)
          m.reply(response) unless response.nil? || response == ""
        end
      end
    end

    def setup_usage_responder
      bot.on(:message, /^#{bot.nick} (usage|help)$/) do |m|
        Anita::Bot.plugins.each do |name, plugin|
          m.reply "#{name}: #{plugin.usage}"
        end
      end

      bot.on(:message, /^#{bot.nick} (usage|help) (.+)$/) do |m, _, name|
        resp = if Anita::Bot.plugins.include?(name)
                 Anita::Bot.plugins[name].usage
               else
                 "unknown plugin"
               end
        m.reply "#{name}: #{resp}"
      end
    end

    def setup_plugins_responder
      bot.on(:message, /^#{bot.nick} plugins$/) do |m|
        m.reply Anita::Bot.plugins.keys.join(", ")
      end
    end
  end
end
