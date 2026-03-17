#!/usr/bin/env ruby
#######
# rdswap.rb (c) C.Hintze <c.hintze@gmx.net> 30.08.1999
#######

require "optparse"

RDDocumentBlock = Struct.new(:kind, :lines)

class RDSwap
  def initialize(argv, stdout: $stdout, stderr: $stderr)
    @argv = argv.dup
    @stdout = stdout
    @stderr = stderr
    @verbose = false
  end

  def run
    parse_options!

    if @argv.size < 2
      @stdout.print("Wrong # of paramter! Use `-h' for help.\n")
      return 1
    end

    source_file = detect_source_file(@argv)
    docs, srcs = load_documents(@argv)

    source_blocks = srcs["rb"]
    source_docs = docs["rb"]
    raise "No source file content found." unless source_blocks && source_docs

    (docs.keys - ["rb"]).each do |lang|
      write_translation(source_file, lang, source_blocks, source_docs, docs[lang])
    end

    0
  end

  private

  def parse_options!
    OptionParser.new do |opts|
      opts.on("-h", "--help") do
        @stdout.print(help_text)
        raise SystemExit.new(0)
      end

      opts.on("-v", "--verbose") do
        @verbose = true
      end
    end.parse!(@argv)
  end

  def help_text
    HELP_TEXT % { program_name: File.basename($PROGRAM_NAME) }
  end

  def detect_source_file(paths)
    source_files = paths.select { |path| path.end_with?(".rb") }
    case source_files.size
    when 0
      @stderr.print "Warning: No `.rb' file given! Take first file as source.\n"
      paths.first
    when 1
      source_files.first
    else
      @stdout.print "Sorry! Only one source file (`.rb') allowed!\n"
      raise SystemExit.new(1)
    end
  end

  def load_documents(paths)
    docs = {}
    srcs = {}

    paths.each do |path|
      lang = File.basename(path).split(".").last
      docs[lang], srcs[lang] = parse_file(path)
    end

    [docs, srcs]
  end

  def parse_file(path)
    rddocs = []
    sources = [[]]
    current_doc = nil

    File.foreach(path) do |line|
      if current_doc
        if line.start_with?("=end")
          rddocs << current_doc
          sources << []
          current_doc = nil
        else
          current_doc.lines << line
        end
        next
      end

      if (match = /\A=begin(?:\s+(.*))?\s*\z/.match(line))
        current_doc = RDDocumentBlock.new(match[1], [])
      else
        sources[-1] << line
      end
    end

    [rddocs, sources]
  end

  def write_translation(source_file, lang, source_blocks, source_docs, translated_docs)
    max = [source_blocks.size, source_docs.size, translated_docs.size].max
    output_path = "#{source_file}.#{lang}"

    File.open(output_path, "w") do |fd|
      translated_index = 0

      (0...max).each do |i|
        fd.print(source_blocks[i].join) if source_blocks[i] && !source_blocks[i].empty?

        source_doc = source_docs[i]
        translated_doc = translated_docs[translated_index]
        block = if source_doc && translated_doc && translated_doc.kind == source_doc.kind
                  translated_index += 1
                  translated_doc
                else
                  source_doc
                end
        next unless block

        fd.print "=begin #{block.kind}\n", block.lines.join, "=end\n"
      end
    end

    @stdout.print "File `#{output_path}' created.\n" if @verbose
  end
end

HELP_TEXT = <<~TEXT
Purpose:
   This tool is written to support you to write multi-language documents
   using the Ruby-Document-Format (RD).

   The idea for such a tool was originated by

                Minero Aoki <aamine@dp.u-netsurf.ne.jp>,

   how has thought about, how to make life easier for developers who have to
   write and maintain scripts in more than one language.

   You have to specify at least two filenames on the command line. One
   containing the Ruby script, the second containing a translated RD. If the
   script does *not* end with `.rb', it has to be the first filename mentioned
   on the command line! In opposition, all files containing translations *must
   not* ending with `.rb'! They should use a extension that describes the
   language. So that would give us the following picture:

      - sample.rb : Script contains the original documentation.
      - sample.jp : Documentation written in Japanese.
      - sample.de : Translation to German.

   The tool doesn't care about the language extensions. You can name them as
   you like! So the file containing the Japanese translation above, could also
   be names e.g. `sample.japan' or even `japantranslation.japan'.

   For every translation file, a new file will be created. The name is build
   from the script filename plus the language extension. So regarding the
   example above, following files would be created:

      - sample.rb.jp
      - sample.rb.de

   or, given the alternative translation filename as mentioned above...

      - sample.rb.japan

How does it work?
   The contents of all files will be split into source and RD blocks. The
   source of the translation files, will be discarded! Every RD block may
   be of a certain type. The type will be taken from the contents directly
   following the `=begin' on the same line. If there is only a lonely `=begin'
   on a line by itself, the type of the block is `nil'. That means in

        :
        =begin
         bla bla
        =end
        :
        =begin whatever or not
         blub blub
        =end
        :

   the first block would be of type `nil' and the second one of type `whatever
   or not'.

   Block types are important for the translation. If a source will be
   generated from a script and a translation file, only these blocks are taken
   from the translation files, that comes in the right sequence *and* contains
   the same type as the block in the script! For example:

        # File sample.rb
        :
        =begin gnark
         Some comment
        =end
        :
        =begin
         block 2
        =end
        :
        =begin
         block 3
        =end
        :

        # File sample.de
        :
        =begin
         Block zwei
        =end
        :
        =begin
         Block drei
        =end
        :

   Here, the first block of `sample.rb' will *not* be translated, as there is
   no translation block with that type in sample.de! So the first block would
   be inserted as-it-is into the translated script. The blocks afterwards,
   however, are translated as the block type does match (it is `nil' there).

   Attention: In a translation file, a second block will only be used, if
              a first one was already used (matched). A third block will
              only be used, if a second one was used already!

   That means, if the first block of `sample.de' would be of type e.g. `Never
   match', then no block would ever be taken to replace anyone of `sample.rb'.

Syntax:
   %{program_name} [-h|-v] <filename>...

Whereby:
   -h  shows this help text.
   -v  shows some more text during processing.
   <filename>  Means a file, that contains RD and/or Ruby code.

Examples:
   %{program_name} -v sample.rb sample.ja sample.de
   %{program_name} -v sample.ja sample.rb sample.de
   %{program_name} -v sample.ja sample.de sample.rb
   %{program_name} -v sample.??

Author:
   Clemens Hintze <c.hintze@gmx.net>.
TEXT

begin
  exit(RDSwap.new(ARGV).run)
rescue SystemExit => e
  raise e
end
