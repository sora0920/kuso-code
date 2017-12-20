require 'net/http'
require 'uri'
require "json"
def post_toot(text, account)  
  vis = "public"
  
  uri = URI.parse("https://#{account[:host]}/api/v1/statuses")
  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Post.new(uri.request_uri)

  data = {
    status: text,
    visibility: vis,
  }.to_json

  token = " Bearer " + account[:token]

  req["Content-Type"] = "application/json"
  req["Authorization"] = token

  req.body = data

  res = https.request(req)

  puts "#{res.code}\n#{res.message}"

end
account = {
  :host => "",
  :token => ""
}

if ARGV[0].nil? || ARGV[0].empty? then
  puts "Error: ARGV[0] is empty!"
  exit!
end 

body = "(´◔౪◔) 「もしもしお母さーん！」 \n母「なにー？」\n( ◠‿◠ )「このマジキチなぁ～にぃ～？？」\n　　 ＿＿_\n　／L(՞ةڼ◔) ／＼\n／|￣￣￣￣|＼／\n　|　　　　|／\n　　 \n母「あー @#{ARGV[0]}   か。今度燃えるゴミに出すよ。」"

post_toot(body, account)
