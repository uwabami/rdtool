module RD

  VERSION = '0.6.38'

  class Version
    attr_reader :name
    attr_reader :major, :minor, :patch_level

    def self.new_from_version_string(name, version_str)
      major, minor, patch_level, = analyze_version_string(version_str)
      Version.new(name, major, minor, patch_level)
    end
    
    def initialize(name, major, minor, patch_level)
      @name = name
      @major = major
      @minor = minor
      @patch_level = patch_level
    end

    def self.analyze_version_string(version_str)
      version_str = clean_up_version_string(version_str)
      version_str.split(/\./).collect{|i| i.to_i }
    end

    def to_s
      result = sprintf("%s %d", @name, @major)
      result += sprintf(".%d", @minor) if @minor
      result += sprintf(".%d", @patch_level) if @patch_level
      result
    end

    def self.clean_up_version_string(version_str)
      if /^\$Version:?\s*(.*)\$/ === version_str
	$1
      else
	version_str
      end
    end
  end
end
