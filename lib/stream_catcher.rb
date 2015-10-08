class StreamCatcher

  attr_accessor :time_remaining
  attr_reader :duration, :collector

  def initialize collector, duration: 5, verbose: false, word_count: 0
    @streaming_client = StreamingClient.new
    @duration = duration.to_i # seconds
    @collector = collector
    @verbose = verbose
    @time_remaining = duration
  end

  def capture
    @streaming_client.stream! do |status|
      begin
        @start_time ||= status.created_at

        elapsed = status.created_at - @start_time
        @time_remaining = duration - elapsed
        break if  @time_remaining <= 0.0

        puts "#{status.created_at}:#{status.user.id} #{status.user.name} - #{status.text[0..30]} " if @verbose
        collector << status.text
      rescue StandardError => e
        puts e.message
        puts e.backtrace
      end
    end
  end

  def result
    collector.inspect
  end
end
