class TwitterAnalyzer
  attr_reader :store, :word_ranks, :verbose, :duration

  def initialize duration: 2, verbose: false, store: SimpleStore.new, stopwords: StopWords.new.words
    @store = store
    @verbose = verbose
    @word_ranks = store.attrs[:word_ranks] || {}
    @duration = remaining_duration || duration
  end

  def capture
    status
    streamer.capture
  end

  def finish
    save_state!
    puts streamer.result
  end

  private

  def status
    if resuming?
      puts "RESUMING for #{@duration} seconds."
      puts collector.inspect
    else
      puts "Running for #{@duration} seconds."
    end
  end

  def remaining_duration
    store.attrs[:time_remaining]
  end

  def resuming?
    (remaining_duration || 0 ) > 0
  end

  def collector
    @collector ||= RankedWords.new(store: store,
                                              word_ranks: word_ranks,
                                              total_word_count: store.attrs[:total_word_count]
                                             )
  end

  def streamer
    @streamer ||= StreamCatcher.new(collector,
                                  duration: duration,
                                  verbose: verbose)
  end

  def save_state!
    store.clear and return if time_expired?
    store.save :time_remaining, time_remaining
    store.save :word_ranks, @collector.word_ranks
  end

  def time_remaining
    streamer.time_remaining
  end

  def time_expired?
    time_remaining <= 0
  end

end

