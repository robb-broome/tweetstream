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

