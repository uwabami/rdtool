# -*- mode: ruby; coding: utf-8 -*-

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'date'

# definition functions
def name
  @name  ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("VERSION")
end

def date
  Date.today.to_s
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

# it's too ad hoc!!
RDINLINEPARSER = "lib/rd/rdinlineparser.tab.rb"
RDINLINEPARSER_SRC = "lib/rd/rdinlineparser.ry"
RDBLOCKPARSER  = "lib/rd/rdblockparser.tab.rb"
RDBLOCKPARSER_SRC  = "lib/rd/rdblockparser.ry"

# standard task
task :default => :test
task :test => :racc
Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/test-*.rb']
  t.verbose = true
end

desc "Update parser"
task :racc => [RDINLINEPARSER, RDBLOCKPARSER]
file RDINLINEPARSER => RDINLINEPARSER_SRC do |t|
  sh "racc -o #{t.name} #{t.prerequisites[0]}"
end
file RDBLOCKPARSER => RDBLOCKPARSER_SRC do |t|
  sh "racc -o #{t.name} #{t.prerequisites[0]}"
end

desc "remove pkg's"
task :clean do
  sh "rm -fr pkg"
  sh "rm -fr coverage"
end
desc "remove all generated files"
task :distclean => :clean do
  sh "rm -fr #{RDBLOCKPARSER}"
  sh "rm -fr #{RDINLINEPARSER}"
  sh "rm -fr *.html"
end

desc "Generate #{gem_file}"
task :build => [:gemspec, :html] do
  sh "mkdir -p pkg"
  sh "gem build #{gemspec_file}"
  sh "mv #{gem_file} pkg/"
end

desc "Update #{gemspec_file}"
task :gemspec => :racc do
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")
  # replace name version and date
  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)
  # replace_header(head, :rubyforge_project)
  files = `git ls-files`.
    split("\n").
    push(RDBLOCKPARSER).
    push(RDINLINEPARSER).
    push("README.html").
    push("README.ja.html").
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

desc "Update html files"
task :html => [:racc, "README.html", "README.ja.html"]
file "README.html" => "README.rd" do |t|
  sh "ruby -Ilib bin/rd2 #{t.prerequisites[0]} > #{t.name}"
end
file "README.ja.html" => "README.rd.ja" do |t|
  sh "ruby -Ilib bin/rd2 #{t.prerequisites[0]} > #{t.name}"
end
