require_relative 'test_helper'

describe Tweet do
  let(:status) {'this is a status'}
  let(:tweet) { Tweet.new status}
  it 'breaks the status into an array' do
    tweet.words.must_be_instance_of Array
  end

  it 'lists all the words in the tweet' do
    tweet.words.count.must_equal status.split.count
  end

  it 'eliminates 1-character words' do
    tweet.meaningful_words.wont_include 'a'
  end

  it 'eliminates words with low meaning' do
    tweet.meaningful_words.wont_include 'the'
  end

  it 'counts total words' do
    tweet.word_count.must_equal status.split.count
  end

end

