# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fig}
  s.version = "0.8.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Hopkins, Hopsoft LLC"]
  s.date = %q{2009-03-16}
  s.description = %q{The smart way to manage configuration settings for your Ruby applications.}
  s.email = %q{natehop@gmail.com}
  s.extra_rdoc_files = ["README.rdoc", "lib/hopsoft/fig.rb", "lib/string.rb", "tasks/fig_tasks.rake"]
  s.files = ["README.rdoc", "install.rb", "MIT-LICENSE", "test/test.yml", "test/test2.yml", "test/string_test.rb", "test/fig_test.rb", "Manifest", "uninstall.rb", "Rakefile", "init.rb", "lib/hopsoft/fig.rb", "lib/string.rb", "tasks/fig_tasks.rake", "fig.gemspec"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/hopsoft/fig}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Fig", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fig}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The smart way to manage configuration settings for your Ruby applications.}
  s.test_files = ["test/string_test.rb", "test/fig_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
