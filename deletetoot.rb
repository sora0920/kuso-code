require "net/http"
require "uri"
require "json"

# Mastodonの投稿全消しスクリプトです。
# C-cでキャンセルできます。
# ruby deletetoot.rb @host @token


def get_current_account_id(host, token)
  uri = URI.parse("https://#{host}/api/v1/accounts/verify_credentials")

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(uri.path)
  req["Authorization"] = "Bearer #{token}"

  res = https.request(req)

  puts "Get Current Account id: #{res.message}"
  return "#{JSON.parse(res.body)["id"]}"
end

def get_current_account_statuses(host, token)
  id = get_current_account_id(host, token)

  uri = URI.parse("https://#{host}/api/v1/accounts/#{id}/statuses")

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(uri.path)
  req["Authorization"] = "Bearer #{token}"

  res = https.request(req)

  puts "Get Current Account Statuses: #{res.message}"
  return JSON.parse(res.body)
end

def delete_statuses(host, token, statuses)
  uri = URI.parse("https://#{host}/api/v1/statuses/#{statuses["id"]}")

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Delete.new(uri.request_uri)
  req["Authorization"] = "Bearer #{token}"

  res = https.request(req)

  puts "Delete Statuses: #{res.message}"
end

def get_current_account_statuses_count(host, token)
  uri = URI.parse("https://#{host}/api/v1/accounts/verify_credentials")

  https = Net::HTTP.new(uri.host, uri.port)
  https.use_ssl = true

  req = Net::HTTP::Get.new(uri.path)
  req["Authorization"] = "Bearer #{token}"

  res = https.request(req)

  puts "Current Account Statuses Count: #{JSON.parse(res.body)["statuses_count"]}"
  return "#{JSON.parse(res.body)["statuses_count"]}"
end

def delete_current_account_statuses(host, token)
  while get_current_account_statuses_count(host, token).to_i > 1
    statuses_ary = get_current_account_statuses(host, token)

    statuses_ary.each{ |statuses|
      delete_statuses(host, token, statuses)
      sleep 3
    }
  end
end

delete_current_account_statuses(ARGV[0], ARGV[1])
