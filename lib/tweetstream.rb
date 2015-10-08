Dir[File.expand_path(File.join('../../lib/*.rb'), __FILE__)].each {|file| puts file; require file }
require 'dotenv'
Dotenv.load
require 'twitter'

class RankedWords
  attr_accessor :tweets, :total_word_count, :word_ranks, :stopwords
  def initialize stopwords
    @tweets = []
    @total_word_count = 0
    @word_ranks = Hash.new(0)
    @stopwords = stopwords.words
  end

  def << tweet
    @tweets << tweet
    words = tweet.downcase.split
    @total_word_count += words.count
    (words - stopwords).each {|word| word_ranks[word] += 1}
  end

  def top n
    sorted = Hash[word_ranks.sort {|a, b| b[1]<=> a[1]}]
    sorted.first(n).map(&:first)
  end

end

class StreamCollection
  def initialize stopwords, duration = 5
    ::TweetStream.configure do |config|
      config.consumer_key       = ENV['CONSUMER_KEY']
      config.consumer_secret    = ENV['CONSUMER_SECRET']
      config.oauth_token        = ENV['OAUTH_TOKEN']
      config.oauth_token_secret = ENV['OAUTH_SECRET']
      config.auth_method        = :oauth
    end
    @client = TweetStream::Client.new
    @start_time = nil
    @collection_duration = duration # seconds
    @collector = RankedWords.new stopwords
  end

  def capture
    @client.sample do |status|
      @start_time ||= status.created_at
      break if (status.created_at - @start_time) > @collection_duration

      begin
        puts "#{status.created_at}:#{status.user.id} #{status.user.name} - #{status.text[0..30]} "
        @collector << status.text
      rescue StandardError => e
        puts e.message
      end
    end
  end

  def result
    puts "Total word count: #{@collector.total_word_count}"
    puts "Top ten words: #{@collector.top(10)}"
  end
end

collector = StreamCollection.new(StopWords.new, 10)
collector.capture
collector.results

