require "test/unit"
require "rd/rd2man-lib"
require "rd/tree"
require "rd/block-element"
require "rd/rd-struct"

include RD

class TestRD2MANLib < Test::Unit::TestCase
  def test_default_man_section_is_1
    visitor = RD2MANVisitor.new

    assert_equal("1", visitor.output_suffix)
  end

  def test_man_section_changes_output_suffix_and_th_header
    visitor = RD2MANVisitor.new
    visitor.man_section = "3"
    visitor.input_filename = "rdtool.rd"

    tree = Tree.new_with_document_struct(DocumentStructure::RD)
    tree.root = DocumentElement.new

    output = visitor.visit(tree)

    assert_equal("3", visitor.output_suffix)
    assert_match(/^\.TH RDTOOL 3 "/, output)
  end

  def test_th_header_uses_basename_instead_of_full_path
    visitor = RD2MANVisitor.new
    visitor.input_filename = "/tmp/path/to/rd2.rd"

    tree = Tree.new_with_document_struct(DocumentStructure::RD)
    tree.root = DocumentElement.new

    output = visitor.visit(tree)

    assert_match(/^\.TH RD2 1 "/, output)
  end

  def test_th_header_uses_output_basename_for_stdin_input
    visitor = RD2MANVisitor.new
    visitor.input_filename = "-"
    visitor.filename = "/tmp/output/rd2"

    tree = Tree.new_with_document_struct(DocumentStructure::RD)
    tree.root = DocumentElement.new

    output = visitor.visit(tree)

    assert_match(/^\.TH RD2 1 "/, output)
  end
end
