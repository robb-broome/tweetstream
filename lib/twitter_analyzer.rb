class TwitterAnalyzer

  attr_reader :streamer, :store

  def initialize collector: nil, duration: 2, verbose: false, store: SimpleStore.new, stopwords: StopWords.new.words
    @store = store
    word_ranks = store.attrs[:word_ranks] || {}
    remaining_duration = store.attrs[:time_remaining]
    @duration = remaining_duration || duration
    @collector = collector || RankedWords.new(store: @store,
                                              word_ranks: word_ranks,
                                              total_word_count: @store.attrs[:total_word_count]
                                             )

    if remaining_duration
      puts "RESUMING for #{@duration} seconds."
      puts "Top 10 words were #{@collector.top(10)}"
    else
      puts "Running for #{@duration} seconds."
    end
    @streamer = StreamCatcher.new(@collector,
                                  duration: @duration,
                                  verbose: verbose)
  end

  def capture
    streamer.capture
  end

  def finish
    puts streamer.result

    if (time_left = streamer.time_remaining) <= 0
      puts 'The timer was finished'
      store.clear
    else
      puts "There were #{time_left} seconds left"
      store.save :time_remaining, time_left
      store.save :word_ranks, @collector.word_ranks
    end

  end

end

