require 'pry-byebug'
require 'json'
require 'active_support'
require 'active_support/core_ext'

TWEET_DATA_PATH = './out/tweet_data.json'

puts "Starting building book data"

tweets = JSON.parse(File.read(TWEET_DATA_PATH)).map do |tweet_data|
  tweet_data['created_at'] = DateTime.iso8601(tweet_data['created_at'])
  tweet_data.deep_symbolize_keys
end

# Remove tweets before 2012 to remove a few random outliers.
tweets.select! do |tweet|
  tweet[:created_at].year > 2012
end

# Tweets grouped by month and year
year_months = tweets.group_by do |tweet|
  tweet[:created_at].strftime('%y %m')
end.to_a.sort_by(&:first).map(&:second)

books = year_months

books.each_with_index do |month_group, i|
  first_time = month_group.first[:created_at]
  time_code = first_time.strftime('%y_%m')
  puts "Book #{i} for year #{first_time.year}, month #{first_time.month} has #{month_group.count} tweets."
  tweets_with_images, tweets_without_images = month_group.partition { |tweet| tweet[:media].count > 0 }
  erb = ERB.new(File.read('book_template.html.erb'))
  result = erb.result_with_hash({
    tweets_without_images: tweets_without_images,
    tweets_with_images: tweets_with_images,
    tweets: month_group,
    rand: Random.new(first_time.to_i)
  })
  File.write("./out/book_#{time_code}.html", result)
end