require 'csv'
require 'json'
require 'pry-byebug'
new_tweets = []
CSV.open("quinnypig_updated_normalized.csv", "wb", headers: [:id, :text, :screen_name]) do |csv|
  csv << ['id', 'text', 'screen_name']
  CSV.foreach('./quinnypig_updated_raw.csv', headers: true) do |tweet_line|
    csv << {
      id: JSON.parse(tweet_line["Tweet Id"]),
      text: tweet_line["Tweet Content"],
      screen_name: tweet_line['Screen Name']
    }
  end
end