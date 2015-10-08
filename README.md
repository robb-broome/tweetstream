#TweetStream

A project for analyzing a sample of twitter data for significant word frequency

You'll need your own twitter credentials, this uses ENV vars to find them.

```
  CONSUMER_KEY
  CONSUMER_SECRET
  OAUTH_TOKEN
  OAUTH_SECRET
```

Run in rake using `bundle exec rake run`

Parameters available:
- duration, integer
- verbose, use '1' to set to verbose mode. This shows a truncated version of the tweets as they arrive.


This streams the Twitter sample `https://stream.twitter.com/1.1/statuses/sample.json` api for 300 seconds, then reports on total word count and the top 10 significant words.

If the collection is interrupted using `ctrl-c`, then restarted it picks up from where it left off. Word rankings and total word count is retained. The next run will continue for the remining duration of the interrupted run until it's finished. 

You can collect for a shorter period of time by giving a param to the run command. 

If the collection period finished (the timer expires), then the score and timer from the last run are erased. 


You can:
 
- replace the persistence with any class that responds to #increment, #save, and #clear
