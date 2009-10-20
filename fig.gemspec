require 'rake'

Gem::Specification.new do |spec|
  spec.version = '1.0'
  spec.name = 'hopsoft-fig'
  spec.summary = 'Easy & powerful configuration utility'
  spec.description = <<-DESC
    Easy & powerful configuration for your Ruby applications.
    Similar to settingslogic with a slightly different approach and a few more features.
  DESC
  spec.authors = ['Nathan Hopkins']
  spec.email = ['natehop@gmail.com']
  spec.bindir = 'bin'
  spec.files = FileList['lib/*.rb', 'lib/**/*.rb', 'bin/*'].to_a
end

