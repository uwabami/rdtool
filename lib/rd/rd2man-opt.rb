=begin
= rd2man-opt.rb
sub-OptionParser for rd2man-lib.rb.
=end

require "optparse"

q = $RD2_OptionParser || ARGV.options

q.on_tail("rd2man-lib options:")

q.on_tail("--man-section=SECTION",
          String,
          "use SECTION as the man page section") do |section|
  $Visitor.man_section = section
end
