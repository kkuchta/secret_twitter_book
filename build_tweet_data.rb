require 'pry-byebug'
require 'csv'
# require 'tweetkit'
require 'twitter'
require 'dotenv/load'
require './cache'

TWEET_DATA_PATH = './out/tweet_data.json'

puts "Starting building tweet_data"

# LIMIT = 10000
LIMIT = 1000000

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
  config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
  config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
  config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
end
@cache = Cache.new(client)

def handle_tweet_line(tweet_line)
  begin
    if @i > LIMIT
      puts "hit limit"
      return :break
    end
    @i+=1
    if @i % 10 == 0
      puts "Fetching #{@i}"
    end

    text = tweet_line['text']
    id = tweet_line['tweet_id']
    screen_name = tweet_line['screen_name']
    if screen_name != 'QuinnyPig'
      puts "Skipping tweet by #{screen_name}"
      return :next
    end
    unless tweet = @cache.tweet(id)
      puts "Skipping tweet because it's missing"
      return :next
    end
    if tweet.retweet?
      puts "Skipping because just a RT"
      return :next
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
    @tweets << tweet_info
  rescue StandardError => e
    binding.pry
    puts "Got error for tweet"
  end
end
@i = 0
@tweets = []

CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
  case handle_tweet_line(tweet_line)
  when :break
    break
  when :next
    next
  end
end
CSV.foreach('./quinnypig_updated_normalized.csv', headers: true) do |tweet_line|
  case handle_tweet_line(tweet_line)
  when :break
    break
  when :next
    next
  end
end

puts "Loop ended, I guess?"
@cache.save_cache(true)

@tweets.uniq! { _1[:id]}

File.write(TWEET_DATA_PATH, @tweets.to_json)
# Tweets grouped by month and year
# year_months = tweets.group_by do |tweet|
#   tweet[:created_at].strftime('%y %m')
# end.to_a.sort_by(&:first).map(&:second)

# erb = ERB.new(File.read('final.html.erb'))
# result = erb.result_with_hash({year_months: year_months})
# File.write('./out/final.html', result)