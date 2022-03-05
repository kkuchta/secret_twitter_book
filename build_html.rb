require 'pry-byebug'
require 'csv'
require 'tweetkit'
require 'dotenv'

puts "Starting building html"
client = Tweetkit::Client.new(bearer_token: 'YOUR_BEARER_TOKEN_HERE')


# CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
#   binding.pry
#   puts 'hereh'
# end
