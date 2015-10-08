# run me with `bundle exec rake run`

class Store
  require 'yaml'
  attr_accessor :attrs, :store_name
  def initialize store_name = 'count_store.yml'
    @store_name = store_name
    puts "store_name is #{store_name}"
    File.open(store_name,'r') do |store|
      @attrs = YAML.load_file(store) || {}
      puts "Loaded attrs #{@attrs}"
    end
  end

  def increment key, val
    attrs[key] ||= 0
    attrs[key] += val
    persist!
  end

  def persist!
    File.open(store_name, 'w') do |file|
      file.write attrs.to_yaml
    end
  end
end

class RankedWords
  attr_accessor :unique_words, :total_meaningful_word_count, :total_word_count, :word_ranks, :stopwords
  def initialize stopwords, persist: false
    @total_word_count = 0
    @total_meaningful_word_count = 0
    @word_ranks = Hash.new(0)
    @unique_meaningful_words = Set.new
    @unique_words = Set.new
    @stopwords = stopwords
    @store = Store.new if @persist = persist
  end

  def << sentence
    words = sentence.downcase.split
    @unique_words.merge words
    word_count = words.count
    increment_total_words word_count
    meaningful_words =  words - stopwords
    @unique_meaningful_words.merge meaningful_words
    meaningful_words.each {|word| word_ranks[word] += 1}
    persist! word_count
  end

  def increment_total_words n
    @total_word_count += n
  end

  def persist! count
    return unless @store
    @store.increment :total_word_count, count
  end


  def top n
    sorted = Hash[word_ranks.sort {|a, b| b[1]<=> a[1]}]
    sorted.first(n).map(&:first)
  end

  def inspect
    "Total word count: #{@total_word_count}\n" <<
    "Unique word count: #{@unique_words.count}\n" <<
    "Total meaningful word count: #{@unique_meaningful_words.count}\n" <<
    "Top meaningful words: #{top(10)}"
  end

end

class StreamingClient
  require 'tweetstream'
  def initialize
    ::TweetStream.configure do |config|
      config.consumer_key       = ENV['CONSUMER_KEY']
      config.consumer_secret    = ENV['CONSUMER_SECRET']
      config.oauth_token        = ENV['OAUTH_TOKEN']
      config.oauth_token_secret = ENV['OAUTH_SECRET']
      config.auth_method        = :oauth
    end
  end

  def client
    @client ||= TweetStream::Client.new
  end

  def stream!
    client.sample do |status|
      yield(status)
    end
  end
end

class StreamCollection
  def initialize collector, duration: 5, verbose: false
    @streaming_client = StreamingClient.new
    @duration = duration.to_i # seconds
    @collector = collector
    @verbose = verbose
  end

  def capture
    @streaming_client.stream! do |status|
      begin
        @start_time ||= status.created_at
        break if (status.created_at - @start_time) > @duration

        puts "#{status.created_at}:#{status.user.id} #{status.user.name} - #{status.text[0..30]} " if @verbose
        @collector << status.text
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def result
    @collector.inspect
  end
end

