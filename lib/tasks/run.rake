desc 'Sample the twitter stream for five minutes and print out the top 10 meaningful words.'
task :run, [:duration, :verbose] do |task, args|

  duration = args[:duration] || 300
  verbose = args[:verbose] == '1'

  analyzer = TwitterAnalyzer.new(verbose: verbose, duration: duration)
  begin
    analyzer.capture
  rescue Interrupt => e
    puts e.message
  rescue => e
    puts "Error: #{e.message}"
    raise
  ensure
    analyzer.finish
  end
end

desc 'Say `rake env` to get a console-like prompt.'
task :env do
  binding.pry
end
