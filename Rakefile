require 'echoe'

Echoe.new('fig', '0.8.2') do |p|
  p.description = "The smart way to manage configuration settings for your Ruby applications."
  p.url = "http://github.com/natehop/fig"
  p.author = "Nathan Hopkins, Hopsoft LLC"
  p.email = "natehop@gmail.com"
  p.ignore_pattern = ["nbproject*"]
  p.development_dependencies = []
  puts p.class
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each {|file| load file}
