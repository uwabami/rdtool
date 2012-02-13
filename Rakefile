# -*- mode: ruby; coding: utf-8 -*-

require 'rubygems'
require 'rake'
require 'rake/testtask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rdtool"
    gem.homepage = "http://github.com/uwabami/rdtool"
    gem.licenses = ['GPL', 'Ruby']
    gem.summary = %Q{RDtool is formatter for RD.}
    gem.description = %Q{RD is multipurpose documentation format created for documentating Ruby and output of Ruby world. You can embed RD into Ruby script. And RD have neat syntax which help you to read document in Ruby script. On the other hand, RD have a feature for class reference.}
    gem.email = "uwabami@gfd-dennou.org"
    gem.authors = ["Youhei SASAKI"]
    gem.extra_rdoc_files = ""
    gem.add_development_dependency "jeweler"
    gem.add_development_dependency "racc"
  end
  Jeweler::RubygemsDotOrgTasks.new
rescue LoadError
  puts "Jeweler not available. If you want to build Gem, please install jeweler"
end

task :default => :test
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test-*.rb']
  t.verbose = true
end
