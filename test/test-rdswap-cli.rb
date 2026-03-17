require "test/unit"
require "open3"
require "rbconfig"
require "tmpdir"
require "fileutils"

class TestRDSwapCLI < Test::Unit::TestCase
  def setup
    @root = File.expand_path("..", __dir__)
    @rdswap = File.join(@root, "bin", "rdswap.rb")
  end

  def test_help_exits_successfully_without_warnings
    _stdout, stderr, status = Open3.capture3(RbConfig.ruby, @rdswap, "-h")

    assert_predicate(status, :success?, stderr)
    assert_no_match(/warning:/i, stderr)
  end

  def test_generates_translated_script
    Dir.mktmpdir("rdswap") do |tmpdir|
      source = File.join(tmpdir, "sample.rb")
      translation = File.join(tmpdir, "sample.ja")

      File.write(source, <<~RUBY)
        puts "hello"
        =begin
        original
        =end
        puts "bye"
      RUBY

      File.write(translation, <<~TEXT)
        =begin
        translated
        =end
      TEXT

      _stdout, stderr, status = Open3.capture3(RbConfig.ruby, @rdswap, source, translation)

      assert_predicate(status, :success?, stderr)
      output = File.read("#{source}.ja")
      assert_match(/puts "hello"/, output)
      assert_match(/translated/, output)
      assert_match(/puts "bye"/, output)
      assert_no_match(/original/, output)
    end
  end
end
