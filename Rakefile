Dir[File.expand_path(File.join('../lib/tasks/**/*.rake'), __FILE__)].each {|file| import file }
require 'rake'
require 'rake/testtask'
require 'pry'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
  t.libs.push 'test'
end

