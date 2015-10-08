require 'minitest/autorun'
require 'minitest/reporters'
require 'pry'
Dir[File.expand_path(File.join('../../lib/*.rb'), __FILE__)].each { |file| require file }

reporter_options = { color: true, slow_count: 5 }
Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new(reporter_options)]
