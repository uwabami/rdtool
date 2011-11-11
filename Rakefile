# -*- mode: ruby; coding: utf-8 -*-

require 'rubygems'
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rdtool"
  gem.homepage = "http://github.com/uwabami/rdtool"
  gem.licenses = ['GPL', 'Ruby']
  gem.summary = %Q{RDtool is formatter for RD.}
  gem.description = %Q{RD is multipurpose documentation format created for documentating Ruby and output of Ruby world. You can embed RD into Ruby script. And RD have neat syntax which help you to read document in Ruby script. On the other hand, RD have a feature for class reference.}
  gem.email = "uwabami@gfd-dennou.org"
  gem.authors = ["Youhei SASAKI"]
  gem.extra_rdoc_files = ""
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

desc "Run tests"
task :test do
  exec_ruby = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])
  exec("#{exec_ruby} -w -v -Ilib:test test.rb")
end
task :default => :test
