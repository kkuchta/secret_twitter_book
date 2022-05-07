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

# Tweets grouped by month and year
year_months = tweets.group_by do |tweet|
  tweet[:created_at].strftime('%y %m')
end.to_a.sort_by(&:first).map(&:second)

years = year_months.group_by do |tweet_month|
  tweet_month.first[:created_at].year
end.select {|year, year_group| year > 2012}

books = []
years.each do |year, year_group|
  i = 
    case year
      when 2016..2018 then 0
      when 2019 then 1
      when 2020 then 2
      when 2021 then 3
    end
  books[i] ||= []
  books[i] += year_group

  puts "Creating book for year #{year} with #{year_group.flatten.count} tweets, goes in book #{i}"
end

# books.each_with_index do |month_group, i|
#   puts "Book #{i}:"
#   month_group.each do |month|
#     puts "  #{month.first[:created_at].strftime('%y %m')}"
#   end
# end

books.each_with_index do |month_group, i|
  erb = ERB.new(File.read('book_template.html.erb'))
  result = erb.result_with_hash({year_months: month_group})
  File.write("./out/book_#{i}.html", result)
end