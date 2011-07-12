#!/usr/bin/env ruby

$VERBOSE = true

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "test"))

load 'test/test-block-parser.rb'
load 'test/test-desclist-item.rb'
load 'test/test-document-element.rb'
load 'test/test-document-struct.rb'
load 'test/test-element.rb'
load 'test/test-headline.rb'
load 'test/test-inline-parser.rb'
load 'test/test-list-item.rb'
load 'test/test-list.rb'
load 'test/test-methodlist-item.rb'
load 'test/test-nonterminal-element.rb'
load 'test/test-nonterminal-inline.rb'
load 'test/test-output-format-visitor.rb'
load 'test/test-parser-util.rb'
load 'test/test-rbl-file.rb'
load 'test/test-rbl-suite.rb'
load 'test/test-rd2html-lib.rb'
load 'test/test-rdtree.rb'
load 'test/test-rdvisitor.rb'
load 'test/test-reference-resolver.rb'
load 'test/test-reference.rb'
load 'test/test-search-file.rb'
load 'test/test-terminal-inline.rb'
load 'test/test-textblock.rb'
load 'test/test-tree.rb'
load 'test/test-version.rb'
load 'test/test-visitor.rb'
