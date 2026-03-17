require "test/unit"
require "open3"
require "rbconfig"
require "tmpdir"
require "fileutils"

class TestRD2CLI < Test::Unit::TestCase
  def setup
    @root = File.expand_path("..", __dir__)
    @rd2 = File.join(@root, "bin", "rd2")
    @libdir = File.join(@root, "lib")
  end

  def test_external_sub_option_parser_registered_via_argv_options_is_shown_in_help
    Dir.mktmpdir("rd2-cli") do |tmpdir|
      write_fake_formatter_files(tmpdir)

      _stdout, stderr, status = run_rd2(tmpdir, "-r", "fake_rd2_visitor", "--help")

      assert_predicate(status, :success?, stderr)
      assert_match(/--fake-flag/, stderr)
    end
  end

  def test_external_sub_option_parser_registered_via_argv_options_is_applied
    Dir.mktmpdir("rd2-cli") do |tmpdir|
      write_fake_formatter_files(tmpdir)
      input = File.join(tmpdir, "sample.rd")
      File.write(input, "=begin\n= sample\n=end\n")

      stdout, stderr, status = run_rd2(tmpdir, "-r", "fake_rd2_visitor", "--fake-flag", input)

      assert_predicate(status, :success?, stderr)
      assert_equal("flag-on\n", stdout)
    end
  end

  def test_rd2man_supports_custom_man_section
    Dir.mktmpdir("rd2-cli") do |tmpdir|
      input = File.join(tmpdir, "sample.rd")
      File.write(input, "=begin\n= sample\n=end\n")

      stdout, stderr, status = run_rd2(nil, "-r", "rd/rd2man-lib", "--man-section=3", input)

      assert_predicate(status, :success?, stderr)
      assert_match(/^\.TH .*SAMPLE 3 "/, stdout)
    end
  end

  private

  def run_rd2(extra_libdir, *args)
    ruby = RbConfig.ruby
    rubylib = [@libdir, extra_libdir, ENV["RUBYLIB"]].compact.join(File::PATH_SEPARATOR)
    Open3.capture3({ "RUBYLIB" => rubylib }, ruby, @rd2, *args)
  end

  def write_fake_formatter_files(tmpdir)
    File.write(File.join(tmpdir, "fake_rd2_visitor.rb"), <<~RUBY)
      class FakeRD2Visitor
        OUTPUT_SUFFIX = "txt"

        attr_accessor :input_filename, :filename, :charcode, :lang, :flag
        attr_reader :include_suffix

        def initialize
          @include_suffix = []
          @flag = false
        end

        def self.version
          "FakeRD2Visitor 1.0"
        end

        def visit(_tree)
          @flag ? "flag-on\\n" : "flag-off\\n"
        end
      end

      $Visitor_Class = FakeRD2Visitor
      $RD2_Sub_OptionParser = "fake_rd2_opt"
    RUBY

    File.write(File.join(tmpdir, "fake_rd2_opt.rb"), <<~RUBY)
      q = ARGV.options
      q.on_tail("--fake-flag", "toggle fake flag") do
        $Visitor.flag = true
      end
    RUBY
  end
end
