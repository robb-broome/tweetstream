#TweetStream

Analyzing a sample of twitter data for significant word frequency!



1. Clone this repo.
2. Bundle
3. You'll need your own Twitter credentials. See [here](https://apps.twitter.com/app/new). I **strongly recommend** that you don't use your own personal twitter account for experimenting. Just create a new account for this.
4. Set these environment variables to your Twitter credentials.

		  CONSUMER_KEY
		  CONSUMER_SECRET
		  OAUTH_TOKEN
		  OAUTH_SECRET

5. Run: `bundle exec rake run[1,1]` to run for 1 second and display the tweets retrieved.

	Parameters: 
	
	- `duration` (optional, default = 300) in seconds
	- `verbose` (optional) to output every tweet. Use '1' to set to verbose mode, any other value for q. This shows a truncated version of the tweets as they arrive.
6. Interruping and restarting the process
  - Saves state, including total word count, time remaining, and the significant word frequency score
  - Allows restart using the same run command. The duration on this command is ignored; the timer will resume where it left off.
6. Test
  - uses MiniTest
  - `bundle exec rake test` to run the suite.

## Example Output

```
$ bundle exec rake run
Running for 300 seconds.
Total word count: 118240
Top meaningful words: weather, people, good, time, know, #emabiggestfansjustinbieber, want, need, can't, updates
```

## How it works

### Access to the twitter sample stream...
...Is provided by the [tweetstream gem](https://github.com/tweetstream/tweetstream). The sample stream is a statistically valid sample of the full public firehose (all twitter traffic).

### Timing
The app uses the Twitter timestamp to keep track of how long capture is done. 

### Persisting state...
...Is done using a file store in YAML format. WHen the timer naturally expires, the store is erased. If a saved state is found when the app starts, that saved state will be used.

## Experimenting
You can play around with the objects in the app with the included 'console' function. Just say `rake env` and instantiate an object, such as 

```
[3] pry(main)> StopWords.new.words.first(10)
=> ["a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all"]

[4] pry(main)>

```

or

```
[5] pry(main)> analyser = TwitterAnalyzer.new(verbose: false, duration: 3)
=> #<TwitterAnalyzer:0x007ffd36138c20
 @duration=3,
 @store=#<SimpleStore:0x007ffd36138bd0 @attrs={:total_word_count=>907}, @store_name="count_store.yml">,
 @verbose=false,
 @word_ranks={}>
[6] pry(main)> analyser.capture
Running for 3 seconds.
=> nil
[7] pry(main)> analyser.finish
Total word count: 1976
Top meaningful words: weather, fine!, água, está, عن, geração, لو, aya.fm, ⬅️, ﷽
=> nil
[8] pry(main)>
```

As you can see, the stop words could use input from other languages.


## Improvements 

- use the EM::PeriodicTimer to control the interval instead of breaking manually.
- The stopwords object needs a more complete list.
- The app could be used to gather tweets for tracking, a user stream, or a site stream.
- Stopwords could be adaptively created by running for a long period and add high frequency words to the stop words object. This would allow for the effects of a momentary trending topic to dissapate.
- Persist stop words so learning this way can be applied to future runs.###
- Replace the persistence with any class that responds to #increment, #save, and #clear.q
- Display the output with scores.
