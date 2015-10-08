Dir[File.expand_path(File.join('../lib/tasks/**/*.rake'), __FILE__)].each {|file| import file }
Dir[File.expand_path(File.join('../lib/*.rb'), __FILE__)].each {|file| require file }
require 'rake'
require 'rake/testtask'
require 'pry'
require 'dotenv'
Dotenv.load

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs.push 'test'
end

