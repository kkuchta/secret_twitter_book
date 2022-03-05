require 'pry-byebug'
require 'csv'
# require 'tweetkit'
require 'twitter'
require 'dotenv/load'
require './cache'

CACHE_FILEPATH='./out/cache.json'

puts "Starting building html"
# puts ENV['TWITTER_API_SECRET']
# client = Tweetkit::Client.new(bearer_token: ENV['TWITTER_BEARER_TOKEN'])
# response = client.tweet(1371960341421125632)

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['client.status(1371960341421125632)T']
end
# tweet = client.status(1371960341421125632)
# binding.pry
@cache = Cache.new(CACHE_FILEPATH, client)
  # if File.exist?(CACHE_FILEPATH)
  #   JSON.parse(File.read(CACHE_FILEPATH))
  # else
  #   {'tweets':{}, 'media': {}}
  # end
# def get_tweet_or_cache(id)
#   if tweet = @cache['tweets'][id]
#   id = id.to_s
#   binding.pry
#   puts 'here'
# end

@cache.tweet('1371960341421125632')
# get_tweet_or_cache('1371960341421125632')
exit

puts "done"
i = 0
CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
  if i > 10
    break
  end
  i+=1

  text = tweet_line['text']
  id = tweet_line['tweet_id']
  tweet = @cache.tweet(id)
  # This tweet includes media
  puts 'hereh'
end
