class Tweet
  attr_reader :sentence, :stopwords
  def initialize sentence
    @sentence = sentence
    @stopwords = StopWords.new.words
  end

  def words
    @sentence.downcase.split
  end

  def word_count
    words.count
  end

  def meaningful_words
    words - @stopwords
  end
end

