require 'active_support'
require 'active_support/core_ext'
require 'open-uri'

CACHE_FOLDER='./out'
CACHE_FILEPATH = CACHE_FOLDER + '/cache.json'

CACHE_EVERY = 1000

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
    # if @_data[:tweets][id]
    if @_data[:tweets].key?(id)
      begin
        if @_data[:tweets][id]
          Twitter::Tweet.new(@_data[:tweets][id])
        else
          # If the key is present, but nil, then it must have been missing last
          # time and we cached that fact.
          @_data[:tweets][id]
        end
      rescue
        binding.pry
      end
    else
      puts "Fetching tweet from api"
      tweet = fetch_tweet(id)
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
      3.times do
        begin
          download = URI.open(media.media_url.to_s)
          IO.copy_stream(download, local_filepath)
          break
        rescue OpenURI::HTTPError => e
          puts "image dl: Got an http error: #{e.full_message}, retrying in 10s"
          sleep 10
        end
      end
    end
    local_filepath
  end

  def save_cache(force=false)
    @save_in ||= CACHE_EVERY
    if @save_in == 0 || force
      start = Time.now
      puts "saving cache"
      File.write(@path, @_data.to_json)
      finish = Time.now
      puts "Completed in #{finish - start} seconds"
      @save_in = CACHE_EVERY
    end
    @save_in -= 1
  end

  private

  def fetch_tweet(id)
    begin
      loop do
        begin
          return @client.status(id.to_s)
        rescue Twitter::Error::TooManyRequests => e
          puts "Got a rate limit error, retrying in a few minutes"
          sleep 30 * 5
        rescue OpenURI::HTTPError => e
          puts "Got an http error: #{e.full_message}, retrying in 10s"
          sleep 10
        rescue HTTP::ConnectionError => e
          puts "Got an http error: #{e.full_message}, retrying in 10s"
        end
      end
    rescue Twitter::Error::Forbidden => e
      puts "Twitter::Error::Forbidden for #{id}"
    rescue Twitter::Error::NotFound => e
      puts "Twitter::Error::NotFound for #{id}"
    rescue Twitter::Error::Unauthorized => e
      if e.message =~ /You have been blocked from the author of this tweet/
        puts "Twitter::Error::Unauthorized for #{id}"
      else
        raise e
      end
    end
    return nil
  end
end