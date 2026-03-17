=begin
= rd2html5-lib.rb
=end

require "rd/rd2html-lib"

module RD
  class RD2HTML5Visitor < RD2HTMLVisitor
    SYSTEM_NAME = "RDtool -- RD2HTML5Visitor"
    SYSTEM_VERSION = "$Version: " + RD::VERSION + "$"
    VERSION = Version.new_from_version_string(SYSTEM_NAME, SYSTEM_VERSION)

    def self.version
      VERSION
    end

    def xml_decl
      nil
    end
    private :xml_decl

    def apply_to_DocumentElement(element, content)
      ret = ""
      ret << doctype_decl + "\n"
      ret << html_open_tag + "\n"
      ret << html_head + "\n"
      ret << html_body(content) + "\n"
      ret << "</html>\n"
      ret
    end

    def doctype_decl
      "<!DOCTYPE html>"
    end
    private :doctype_decl

    def html_open_tag
      lang_attr = %[ lang="#{@lang}"] if @lang
      %|<html#{lang_attr}>|
    end
    private :html_open_tag

    def html_content_type
      %Q[<meta charset="#{@charset}">] if @charset
    end
    private :html_content_type

    def apply_to_Headline(element, title)
      anchor = get_anchor(element)
      label = hyphen_escape(element.label)
      title = title.join("")
      %Q[<h#{element.level} id="#{anchor}">#{title}</h#{element.level}>] +
        %Q[<!-- RDLabel: "#{label}" -->]
    end

    def apply_to_DescListItem(element, term, description)
      anchor = get_anchor(element.term)
      label = hyphen_escape(element.label)
      term = term.join("")
      if description.empty?
        %Q[<dt id="#{anchor}">#{term}</dt><!-- RDLabel: "#{label}" -->]
      else
        %Q[<dt id="#{anchor}">#{term}</dt><!-- RDLabel: "#{label}" -->\n] +
          %Q[<dd>\n#{description.join("\n").chomp}\n</dd>]
      end
    end

    def apply_to_MethodListItem(element, term, description)
      term = parse_method(term)
      anchor = get_anchor(element.term)
      label = hyphen_escape(element.label)
      if description.empty?
        %Q[<dt id="#{anchor}"><code>#{term}</code></dt><!-- RDLabel: "#{label}" -->]
      else
        %Q[<dt id="#{anchor}"><code>#{term}</code></dt><!-- RDLabel: "#{label}" -->\n] +
          %Q[<dd>\n#{description.join("\n")}</dd>]
      end
    end

    def apply_to_Index(element, content)
      tmp = []
      element.each do |i|
        tmp.push(i) if i.is_a?(String)
      end
      key = meta_char_escape(tmp.join(""))
      if @index.has_key?(key)
        %Q[<!-- Index, but conflict -->#{content.join("")}<!-- Index end -->]
      else
        num = @index[key] = @index.size
        anchor = a_name("index", num)
        %Q[<span id="#{anchor}">#{content.join("")}</span>]
      end
    end

    def apply_to_Footnote(element, content)
      num = get_footnote_num(element)
      raise ArgumentError, "[BUG?] #{element} is not registered." unless num

      add_foottext(num, content)
      anchor = a_name("footmark", num)
      href = a_name("foottext", num)
      %Q|<a id="#{anchor}" href="##{href}"><sup><small>*#{num}</small></sup></a>|
    end

    def apply_to_Foottext(element, content)
      num = get_footnote_num(element)
      raise ArgumentError, "[BUG] #{element} isn't registered." unless num
      anchor = a_name("foottext", num)
      href = a_name("footmark", num)
      content = content.join("")
      %|<a id="#{anchor}" href="##{href}"><sup><small>*#{num}</small></sup></a>| +
        %|<small>#{content}</small><br>|
    end
  end
end

$Visitor_Class = RD::RD2HTML5Visitor
$RD2_Sub_OptionParser = "rd/rd2html-opt"
