# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{fig}
  s.version = "0.8.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Nathan Hopkins, Hopsoft LLC"]
  s.date = %q{2009-03-18}
  s.description = %q{The smart way to manage configuration settings for your Ruby applications.}
  s.email = %q{natehop@gmail.com}
  s.extra_rdoc_files = ["lib/hopsoft/fig.rb", "lib/string.rb", "README.rdoc", "tasks/fig_tasks.rake"]
  s.files = ["fig.gemspec", "init.rb", "install.rb", "lib/hopsoft/fig.rb", "lib/string.rb", "Manifest", "MIT-LICENSE", "Rakefile", "README.rdoc", "tasks/fig_tasks.rake", "test/fig_test.rb", "test/string_test.rb", "test/test.yml", "test/test2.yml", "uninstall.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/hopsoft/fig}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Fig", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{fig}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{The smart way to manage configuration settings for your Ruby applications.}
  s.test_files = ["test/fig_test.rb", "test/string_test.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
