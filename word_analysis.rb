require 'csv'
require 'pry-byebug'

@word_frequency = {}

@word_count = 6
@word_string_frequency = {}

def handle_tweet_line(tweet_line)
  text = tweet_line['text']
  words = text.split(' ')
  words.each_cons(@word_count) do |word_sub_array|
    word_substring = word_sub_array.join(' ')
    @word_string_frequency[word_substring] ||= 0
    @word_string_frequency[word_substring] += 1
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
CSV.foreach('./quinnypig_raw.csv', headers: true) do |tweet_line|
  case handle_tweet_line(tweet_line)
  when :break
    break
  when :next
    next
  end
end
top_word_strings = @word_string_frequency.entries.sort_by(&:last).reverse
binding.pry
puts 'done'