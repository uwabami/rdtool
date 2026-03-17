# -*- coding: utf-8; mode: ruby -*-
Gem::Specification.new do |s|
  s.name = 'rdtool'
  s.version = '0.6.39'
  s.date = '2026-03-17'

  s.summary = "Formatter and converter for RD documents."
  s.description = "RDtool parses RD documents and converts them to formats such as HTML and roff. It also includes utilities for working with RD embedded in Ruby source files."
  s.authors = ["Youhei SASAKI"]
  s.email = "uwabami@gfd-dennou.org"
  s.homepage = "https://github.com/uwabami/rdtool"
  s.licenses = ["GPL-2.0-or-later", "Ruby"]
  s.required_ruby_version = ">= 3.2"
  s.require_paths = ["lib"]
  s.executables = %w[rd2 rdswap.rb]
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/uwabami/rdtool/issues",
    "changelog_uri" => "https://github.com/uwabami/rdtool/blob/main/HISTORY",
    "source_code_uri" => "https://github.com/uwabami/rdtool",
  }

  s.add_dependency('nkf', '>= 0.1', '< 1.0')
  s.add_development_dependency('racc', "~> 1.4")
  s.add_development_dependency('test-unit', "~> 3.0")
  s.add_development_dependency('rake', "~> 13.0")

  # = MANIFEST =
  s.files = %w[
    COPYING.txt
    Gemfile
    HISTORY
    LGPL-2.1
    LICENSE.txt
    README.html
    README.ja.html
    README.rd
    README.rd.ja
    Rakefile
    TODO
    bin/rd2
    bin/rdswap.rb
    doc/rd-draft.html
    doc/rd-draft.ja.html
    doc/rd-draft.rd
    doc/rd-draft.rd.ja
    lib/rd/block-element.rb
    lib/rd/complex-list-item.rb
    lib/rd/desclist.rb
    lib/rd/document-struct.rb
    lib/rd/dot.rd2rc
    lib/rd/element.rb
    lib/rd/filter.rb
    lib/rd/head-filter.rb
    lib/rd/inline-element.rb
    lib/rd/labeled-element.rb
    lib/rd/list.rb
    lib/rd/loose-struct.rb
    lib/rd/methodlist.rb
    lib/rd/output-format-visitor.rb
    lib/rd/package.rb
    lib/rd/parser-util.rb
    lib/rd/post-install
    lib/rd/pre-setup.rb
    lib/rd/rbl-file.rb
    lib/rd/rbl-suite.rb
    lib/rd/rd-struct.rb
    lib/rd/rd2html-ext-lib.rb
    lib/rd/rd2html-ext-opt.rb
    lib/rd/rd2html-lib.rb
    lib/rd/rd2html-opt.rb
    lib/rd/rd2html5-lib.rb
    lib/rd/rd2man-lib.rb
    lib/rd/rd2man-opt.rb
    lib/rd/rd2rdo-lib.rb
    lib/rd/rd2rmi-lib.rb
    lib/rd/rdblockparser.ry
    lib/rd/rdblockparser.tab.rb
    lib/rd/rdfmt.rb
    lib/rd/rdinlineparser.ry
    lib/rd/rdinlineparser.tab.rb
    lib/rd/rdvisitor.rb
    lib/rd/reference-resolver.rb
    lib/rd/search-file.rb
    lib/rd/tree.rb
    lib/rd/version.rb
    lib/rd/visitor.rb
    rdtool.gemspec
    setup.rb
    test/data/includee1.html
    test/data/includee2.html
    test/data/includee3.nothtml
    test/data/includee4.xhtml
    test/data/label.rbl
    test/data/label2.rbl
    test/data/sub/includee2.html
    test/data/sub/includee4.html
    test/dummy-observer.rb
    test/dummy.rb
    test/temp-dir.rb
    test/test-block-parser.rb
    test/test-desclist-item.rb
    test/test-document-element.rb
    test/test-document-struct.rb
    test/test-element.rb
    test/test-headline.rb
    test/test-inline-parser.rb
    test/test-list-item.rb
    test/test-list.rb
    test/test-methodlist-item.rb
    test/test-nonterminal-element.rb
    test/test-nonterminal-inline.rb
    test/test-output-format-visitor.rb
    test/test-parser-util.rb
    test/test-rbl-file.rb
    test/test-rbl-suite.rb
    test/test-rd2-cli.rb
    test/test-rd2html-lib.rb
    test/test-rd2html5-lib.rb
    test/test-rd2man-lib.rb
    test/test-rdswap-cli.rb
    test/test-rdtree.rb
    test/test-rdvisitor.rb
    test/test-reference-resolver.rb
    test/test-reference.rb
    test/test-search-file.rb
    test/test-terminal-inline.rb
    test/test-textblock.rb
    test/test-tree.rb
    test/test-version.rb
    test/test-visitor.rb
    utils/rd-mode.el
  ]
  # = MANIFEST =

end
