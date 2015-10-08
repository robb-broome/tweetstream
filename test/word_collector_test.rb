require_relative 'test_helper'

describe RankedWords do
  let(:stopwords) {StopWords.new}
  let(:rankings) {RankedWords.new stopwords}
  let(:tweet) {'yo cubs win'}

  it 'accepts a tweet' do
    rankings << tweet
    rankings.tweets.must_include tweet
  end

  it 'filters basic stopwords' do
    rankings << tweet
    rankings.word_ranks['yo'].must_equal 0
  end

  it 'filters 1 character words' do
    rankings << 'a b c d pennant'
    ranked = rankings.top(10)
    ranked.count.must_equal 1
  end

  it 'ranks significant words by frequency' do
    rankings << 'cubs'
    rankings << 'cubs win!'
    rankings << 'cubs win!'
    rankings << 'pirates'
    rankings.top(10).must_equal ['cubs','win!','pirates']

  end

  it 'has a total count of words' do
    rankings << tweet
    rankings.total_word_count.must_equal 3
  end
end

describe StopWords do
  let(:stopwords) {StopWords.new}
  it 'has a list of meaningless words' do
    stopwords.words.must_be_instance_of Array
  end

  it 'allows adding a stopword' do
    meaningless_word = 'meaninglessWord'
    stopwords << meaningless_word
    stopwords.words.must_include meaningless_word
  end
end
