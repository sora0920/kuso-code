require 'net/http'
require 'uri'
require "json"
require "eventmachine"
require "faye/websocket"
require 'nokogiri'
def stream(account, toots)
  EM.run do
    ws = Faye::WebSocket::Client.new(
      "wss://#{account[:host]}/api/v1/streaming?access_token=#{account[:token]}&stream=user",
    )
      ws.on :open do |e|
        puts "open"
      end

      ws.on :error do |e|
        puts e
      end

      ws.on :close do |e|
        puts "connection close."
        puts e      
      end

      ws.on :message do |msg|
        toot = JSON.parse(msg.data)
        if toot["event"] == "notification"
          toot_body = JSON.parse(toot["payload"])
          if toot_body["type"] == "mention"
            body = "@#{toot_body["account"]["acct"]} スゥ…#{toot_body["account"]["display_name"]}の守護霊です…"
            post_toot(body, toot_body["status"]["id"], account)
          end
          # なんかする
        end
      end
  end
end

def post_toot(text, id, account)  
  vis = "unlisted"
  
  uri = URI.parse("https://#{account[:host]}/api/v1/statuses")
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Post.new(uri.request_uri)

  data = {
    status: text,
    visibility: vis,
    in_reply_to_id: id
  }.to_json

  token = " Bearer " + account[:token]

  req["Content-Type"] = "application/json"
  req["Authorization"] = token

  req.body = data

  res = https.request(req)

  puts "#{res.code}\n#{res.message}"

end

account = {
  :host => "social.mikutter.hachune.net",
  :token => ""
}

toots = []
stream(account, toots)
