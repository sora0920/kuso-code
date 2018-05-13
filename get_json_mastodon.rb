require 'net/http'
require 'uri'
require 'json'

# MastodonのTootのURL(e.g. https://mstdn.maud.io/@BrownSugar/100005707571838975 )を引数にいれると投稿のJSONを取得してJSONファイルとして出力するスクリプトです。
# 公開投稿のみに対応しています。

toot = ARGV[0].to_s

host = URI(toot).host

id = toot.match(/\d+$/)


URL = "https://#{host}/api/v1/statuses/#{id}"

uri = URI.parse(URL)
https = Net::HTTP.new(uri.host, uri.port)
https.use_ssl = true

req = Net::HTTP::Get.new(uri.request_uri)

res = https.request(req)

status = res.body

puts res.code

File.open("#{JSON.parse(status)["id"]}.json", "w") do |f|
  f.puts(status)
end
