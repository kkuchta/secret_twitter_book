require 'pry-byebug'
require 'csv'
# require 'tweetkit'
require 'twitter'
require 'dotenv/load'
require './cache'


puts "Starting building html"

LIMIT = 1000

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['client.status(1371960341421125632)T']
end
# tweet = client.status(1371960341421125632)
@cache = Cache.new(client)

puts "done"
i = 0
tweets = []
CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
  begin
    if i > LIMIT
      break
    end
    i+=1
    if i % 10 == 0
      puts "Fetching #{i}"
    end

    text = tweet_line['text']
    id = tweet_line['tweet_id']
    screen_name = tweet_line['screen_name']
    if screen_name != 'QuinnyPig'
      puts "Skipping tweet by #{screen_name}"
      next
    end
    unless tweet = @cache.tweet(id)
      puts "Skipping tweet because it's missing"
      next
    end
    if tweet.retweet?
      puts "Skipping because just a RT"
      next
    end
    # if tweet.quoted_tweet?
    #   puts "FOUND A QUOTED TWEET #{id}"
    # end
    tweet_info = {
      id: id,
      text: text,
      media: [],
      created_at: tweet.created_at
    }
    if tweet.media?
      tweet.media.each do |media|
        local_media_filepath = @cache.local_media(media)
        tweet_info[:media] << local_media_filepath.gsub('./out/','')
      end
      # Remove the t.co link to this media.
      text.sub!(%r{https://t.co/\w+}, '')
    end
    tweets << tweet_info
  rescue StandardError => e
    binding.pry
    puts "Got error for tweet"
  end
end
@cache.save_cache

erb = ERB.new(File.read('final.html.erb'))
result = erb.result_with_hash({tweets: tweets})
File.write('./out/final.html', result)