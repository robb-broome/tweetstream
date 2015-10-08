class RankedWords

  attr_accessor :total_word_count, :unique_words, :unique_meaningful_words, :word_ranks

  def initialize store: nil, total_word_count: 0, word_ranks: {}
    @total_word_count = total_word_count || 0
    @word_ranks = word_ranks
    @word_ranks.default = 0
    @unique_meaningful_words = Set.new
    @unique_words = Set.new
    @store = store
  end

  def << status
    sentence = Tweet.new status
    collect_unique_words sentence.words
    increment_total_word_count_by sentence.word_count
    score_words sentence.meaningful_words
  end

  def collect_unique_words words
    @unique_words.merge words
  end

  def score_words meaningful_words
    unique_meaningful_words.merge meaningful_words
    meaningful_words.each {|word| word_ranks[word] += 1}
  end

  def increment_total_word_count_by n
    @total_word_count += n
    @store.increment :total_word_count, n
  end

  def top n
    sorted = Hash[word_ranks.sort {|a, b| b[1]<=> a[1]}]
    sorted.first(n).map(&:first)
  end

  def inspect
    "Total word count: #{@total_word_count}\n" <<
    "Top meaningful words: #{top(10).join(', ')}"
  end

end
