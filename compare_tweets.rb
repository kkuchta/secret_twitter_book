require 'pry-byebug'
require 'csv'
require 'json'

old_tweets = []
CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
  old_tweets << {
    id: tweet_line['tweet_id'],
    created_at: DateTime.parse(tweet_line['timestamp']),
    text: tweet_line['text']
  }
end

new_tweets = []
CSV.foreach('./quinnypig_updated_raw.csv', headers: true) do |tweet_line|

  new_tweets << {
    id: JSON.parse(tweet_line["Tweet Id"]),
    created_at: DateTime.parse(tweet_line["Tweet Posted Time (UTC)"]),
    text: tweet_line["Tweet Content"]
  }
end


new_tweets.sort_by!{_1['created_at']}
old_tweets.sort_by!{_1['created_at']}

oldest_new_tweet = new_tweets.first
newest_old_tweet = old_tweets.last

old_tweets_in_range = old_tweets.select do |tweet|
  tweet[:created_at] >= oldest_new_tweet[:created_at] &&
    tweet[:created_at] <= newest_old_tweet[:created_at]
end
new_tweets_in_range = new_tweets.select do |tweet|
  tweet[:created_at] >= oldest_new_tweet[:created_at] &&
    tweet[:created_at] <= newest_old_tweet[:created_at]
end

old_tweets_in_range_ids = old_tweets_in_range.map{_1[:id]}
new_tweets_in_range_ids = new_tweets_in_range.map{_1[:id]}

# 162 tweets here
tweets_in_old_but_not_new = old_tweets_in_range_ids - new_tweets_in_range_ids

# 330 tweets here
tweets_in_new_but_not_old = new_tweets_in_range_ids - old_tweets_in_range_ids

puts "tweets_in_old_but_not_new:#{tweets_in_old_but_not_new.count}"
puts "tweets_in_new_but_not_old:#{tweets_in_new_but_not_old.count}"
# Conclusion: close enough!