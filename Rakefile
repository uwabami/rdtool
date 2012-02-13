# -*- mode: ruby; coding: utf-8 -*-
require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'date' unless defined? Date

#############################################################################
#  Helper functions
#############################################################################
def name
  @name  ||= Dir['*.gemspec'].first.split('.').first
end

def version
  require './lib/rd/version.rb'
  RD::VERSION
  # File.read('VERSION')
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

# src files for parser and html documents
RACC_SRC = FileList['lib/rd/*.ry']
RACC_GENERATED = RACC_SRC.ext('.tab.rb')
HTML_SRC = FileList['**/*.rd']
HTML_GENERATED = HTML_SRC.ext('.html')
HTML_JA_SRC = FileList['**/*.rd.ja']
HTML_JA_GENERATED = HTML_JA_SRC.collect{|x| x.gsub(/\.rd\.ja/,'.ja.html')}
GENERATED_FILES = RACC_GENERATED + HTML_GENERATED + HTML_JA_GENERATED

desc "Update parser"
task :racc => RACC_GENERATED
RACC_SRC.each do |f|
  file f.ext('.tab.rb') => f do |t|
    sh "racc -o #{t.name} #{t.prerequisites[0]}"
  end
end
desc "Update html files"
task :doc => [:racc, :html, :html_ja]
task :html => HTML_GENERATED
HTML_SRC.each do |f|
  file f.ext('.html') => f do |t|
    sh "ruby -Ilib bin/rd2 #{t.prerequisites[0]} > #{t.name}"
  end
end
task :html_ja => HTML_JA_GENERATED
HTML_JA_SRC.each do |f|
  file f.gsub(/\.rd\.ja/,'.ja.html') => f do |t|
    sh "ruby -Ilib bin/rd2 #{t.prerequisites[0]} > #{t.name}"
  end
end

task :default => :test

task :test => :racc
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test-*.rb']
  t.verbose = true
end

desc "remove pkg"
task :clean do
  sh "rm -fr pkg"
end
desc "remove all generated files"
task :distclean => :clean do
  sh "rm -fr VERSION"
  sh "rm -fr #{RACC_GENERATED.join(' ')}"
  sh "rm -fr #{HTML_GENERATED.join(' ')}"
  sh "rm -fr #{HTML_JA_GENERATED.join(' ')}"
end

desc "Create tag v#{version} and build and push #{gem_file} to Rubygems"
task :release => :build do
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  sh "git commit --allow-empty -a -m 'Release #{version}'"
  sh "git tag v#{version}"
  sh "git push origin master"
  sh "git push origin v#{version}"
  sh "gem push pkg/#{name}-#{version}.gem"
end


desc "Generate #{gem_file}"
task :build => [:gemspec] do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg/"
end

desc "Update #{gemspec_file}"
task :gemspec => [:racc, :html, :validate] do
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")
  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  # replace_header(head, :rubyforge_project)
  files = (`git ls-files`.split("\n") + GENERATED_FILES.to_a).
    sort.
    reject {|file| file =~/^\./}.
    reject {|file| file =~/^(rdoc|pkg)/}.
    map {|file| "    #{file}" }.
    join("\n")
  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w'){ |io| io.write(spec)}
  puts "Update #{gemspec_file}"
end

