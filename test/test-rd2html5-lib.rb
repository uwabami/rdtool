require "test/unit"

require "rd/rd2html5-lib"
require "rd/tree"
require "rd/block-element"
require "rd/desclist"
require "rd/methodlist"
require "rd/inline-element"
require "rd/rd-struct"

include RD

class TestRD2HTML5Visitor < Test::Unit::TestCase
  def setup
    @vis = RD2HTML5Visitor.new
    @vis.class.module_eval do
      public :xml_decl
      public :doctype_decl
      public :html_open_tag
      public :html_content_type
    end
  end

  def test_html5_head_pieces
    @vis.lang = "en"
    @vis.charset = "utf-8"

    assert_equal(nil, @vis.xml_decl)
    assert_equal("<!DOCTYPE html>", @vis.doctype_decl)
    assert_equal('<html lang="en">', @vis.html_open_tag)
    assert_equal('<meta charset="utf-8">', @vis.html_content_type)
  end

  def test_apply_to_headline_uses_id_without_anchor_tag
    tr = Tree.new_with_document_struct(DocumentStructure::RD)
    tr.root = DocumentElement.new
    headline = nil
    tr.root.build do
      headline = new Headline, 1 do
        new StringElement, "headline"
      end
    end
    @vis.prepare_labels(tr, "label:")

    assert_equal('<h1 id="label:0">headline</h1><!-- RDLabel: "headline" -->',
                 @vis.apply_to_Headline(headline, ["headline"]))
  end

  def test_apply_to_desclist_item_uses_id_on_dt
    tr = Tree.new_with_document_struct(DocumentStructure::RD)
    tr.root = DocumentElement.new
    item = nil
    tr.root.build do
      new DescList do
        item = new DescListItem do
          make_term do
            new StringElement, "term"
          end
        end
      end
    end
    @vis.prepare_labels(tr, "label:")

    assert_equal('<dt id="label:0">term</dt><!-- RDLabel: "term" -->',
                 @vis.apply_to_DescListItem(item, ["term"], []))
  end
end
