task :run, [:duration, :verbose, :persist] do |task, args|
  duration = args[:duration] || 2
  collector = RankedWords.new(StopWords.new.words, persist: args[:persist])
  streamer = StreamCollection.new(collector, duration: duration, verbose: args[:verbose])
  streamer.capture
  puts streamer.result
end

task :env do
  binding.pry
end
