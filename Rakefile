require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'echoe'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the fig plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end

desc 'Generate documentation for the fig plugin.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Fig'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Echoe.new('fig', '0.8.0') do |p|
  p.description = "The smart way to manage configuration settings for your Ruby applications."
  p.url = "http://github.com/natehop/fig"
  p.author = "Nathan Hopkins"
  p.email = "natehop@gmail.com"
  p.ignore_pattern = ["nbproject*"]
  p.development_dependencies = []
  puts p.class
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|file| load file}
