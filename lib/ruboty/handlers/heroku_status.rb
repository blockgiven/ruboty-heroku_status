require 'json'
require 'open-uri'

module Ruboty
  module Handlers
    class HerokuStatus < Base
      on /(h|H)eroku(?:調子)?(悪い|よくない|つながらない|繋がらない|どう|いかが|まずい)(です|だろう)?(\?|？)?/, name: 'heroku_status', description: "Heroku調子どうよ?", all: true

      def heroku_status(message)
        res = OpenURI.open_uri("https://status.heroku.com/api/v3/current-status")
        status = JSON.parse(res.read)
        if status['status'].any? {|_, s| s != "green" }
          issues = status['issues']
          messages = [
            %w{(☝ ՞ਊ ՞)☝ｷｴｴｴｴ ふぇっ げっ え。。。 greenぢゃなぃじゃん。。 もぅﾏﾁﾞ無理。 ぃみゎかんなぃ。。}.shuffle.shuffle.sample,
          ]
          messages << issues.map {|issue| [issue['title'], issue['href']] }.flatten
          message.reply(messages.join($/))
        else
          message.reply([
            %w(めっちゃ クソ ごっつ とても はー).shuffle.shuffle.sample,
            %w(いい 緑 よい いい感じ http://tiqav.com/RW.jpg).shuffle.shuffle.sample
          ].join(' '))
        end
      rescue
        message.reply("Heroku返事がない...")
      end
    end
  end
end
