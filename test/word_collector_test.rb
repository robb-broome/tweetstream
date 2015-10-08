require_relative 'test_helper'

def cleanup_storage
  Dir['*.yml'].each do |file|
    File.delete file
  end
end

describe :storage do
  after :each do
    cleanup_storage
  end

  subject {SimpleStore}

  let(:store_name) {"#{Time.now.to_f.to_s}.yml"}
  let(:store) {subject.new store_name}

  it 'has attrs even if no store is present' do
    store.attrs.must_equal(Hash.new)
  end

  it 'persists values' do
    store.increment :random, 1
    new_store = subject.new store_name
    new_store.attrs.must_equal random: 1
  end

  it 'clears the store' do
    store.increment :random, 1
    store.clear
    new_store = subject.new store_name
    new_store.attrs.must_equal Hash.new
  end
end

describe RankedWords do
  let(:stopwords) {StopWords.new.words}
  let(:rankings) {RankedWords.new store: SimpleStore.new}
  let(:tweet) {'yo cubs win'}

  it 'accepts a tweet' do
    rankings << tweet
    included =  rankings.unique_words <= Set.new(tweet.split)
    included.must_equal true
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
