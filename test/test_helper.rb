class String
  def /(other)
    File.join(self, other)
  end
end

class File
  def self.here
    dirname(__FILE__)
  end
end

require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'yaml'
require File.here / '..' / 'lib' / 'twitter_search'
require File.here / '..' / 'shoulda_macros' / 'twitter_search'

class Test::Unit::TestCase

  def read_yaml(opts = {})
    if opts[:file].nil?
      raise ArgumentError
    end
    YAML.load_file(File.here / 'yaml' / "#{opts[:file]}.yaml")
  end

end
