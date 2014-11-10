# -*- encoding : utf-8 -*-
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "im_helpers"
    gem.summary = %Q{immatériel.fr helpers lib}
    gem.description = %Q{immatériel.fr helpers lib}
    gem.email = "jboulnois@immateriel.fr"
    gem.homepage = "http://github.com/immateriel/im_helpers"
    gem.authors = ["julbouln"]
    gem.files = Dir.glob('lib/**/*')

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/  20 for additional settings
    gem.add_dependency "nokogiri"
    gem.add_dependency "htmlentities"
    gem.add_dependency "unidecoder"
    gem.add_dependency "html_truncator"
    gem.add_dependency "iso-639"
    gem.add_dependency "countries"
    gem.add_dependency "currencies"
    gem.add_dependency "activesupport"
    gem.add_dependency "i18n"

  end
  Jeweler::GemcutterTasks.new

  require 'rake/testtask'
  Rake::TestTask.new(:test) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
  end

  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/test_*.rb'
    test.verbose = true
    test.rcov_opts << '--exclude "gems/*"'
  end

  task :default => :test


rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
