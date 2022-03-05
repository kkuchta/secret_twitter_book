require 'active_support'
require 'active_support/core_ext'

# A simple json cache in the filesystem
class Cache
  def initialize(path, client)
    @path = path
    @client = client
    @_data = if File.exist?(path)
      # Symbolize because that's how the twitter lib expects it.
      JSON.parse(File.read(path)).deep_symbolize_keys
    else
      {tweets:{}, media: {}}
    end
  end

  def tweet(id)
    # Because we're deep_symbolizing all keys, gotta have a symbol id.
    id = id.to_sym
    if @_data[:tweets][id]
      Twitter::Tweet.new(@_data[:tweets][id])
    else
      puts "Fetching tweet from api"
      tweet = @client.status(id.to_s)
      @_data[:tweets][id] = tweet.to_h
      save_cache
      tweet
    end
  end

  def save_cache
    File.write(@path, @_data.to_json)
  end
end