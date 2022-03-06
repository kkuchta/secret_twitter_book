require 'active_support'
require 'active_support/core_ext'
require 'open-uri'

CACHE_FOLDER='./out'
CACHE_FILEPATH = CACHE_FOLDER + '/cache.json'

# A simple json cache in the filesystem
class Cache
  def initialize(client)
    @path = CACHE_FILEPATH
    @client = client
    @_data = if File.exist?(@path)
      # Symbolize because that's how the twitter lib expects it.
      JSON.parse(File.read(@path)).deep_symbolize_keys
    else
      {tweets:{}, media: {}}
    end
  end

  def tweet(id)
    # Because we're deep_symbolizing all keys, gotta have a symbol id.
    id = id.to_sym
    if @_data[:tweets][id]
      begin
        Twitter::Tweet.new(@_data[:tweets][id])
      rescue
        binding.pry
      end
      puts 'here'
    else
      puts "Fetching tweet from api"
      begin
        tweet = @client.status(id.to_s)
      rescue Twitter::Error::NotFound => e
        puts "Twitter::Error::NotFound for #{id}"
      end
      @_data[:tweets][id] = tweet&.to_h
      save_cache
      tweet
    end
  end

  def local_media(media)
    local_filepath = CACHE_FOLDER + '/media/' + media.id.to_s
    begin
      FileUtils.mkdir './out/media'
    rescue Errno::EEXIST
      # Don't care
    end
    if File.exist?(local_filepath)
      puts 'local media already downloaded'
    else
      puts "Downloading media #{media.id}"
      download = URI.open(media.media_url.to_s)
      IO.copy_stream(download, local_filepath)
    end
    local_filepath
  end

  def save_cache
    File.write(@path, @_data.to_json)
  end
end