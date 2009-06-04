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
begin require 'redgreen'; rescue LoadError; end
require 'yaml'
require File.here / '..' / 'lib' / 'twitter_search'
require File.here / '..' / 'shoulda_macros' / 'twitter_search'

gem('fakeweb', '>=1.2.0')
require 'fakeweb'

# an insurance policy against hitting http://twitter.com
FakeWeb.allow_net_connect = false

class Test::Unit::TestCase
  def read_yaml(opts = {})
    raise ArgumentError if opts[:file].nil?
    YAML.load_file(File.here / 'yaml' / "#{opts[:file]}.yaml")
  end

  def parse_json(opts = {})
    raise ArgumentError if opts[:file].nil?
    json = IO.read(File.here / 'json' / "#{opts[:file]}.json")
    JSON.parse(json)
  end

  def convert_date(date)
    date = date.split(' ')
    DateTime.new(date[3].to_i, convert_month(date[2]), date[1].to_i)
  end

  def convert_month(str)
    months = { 'Jan' => 1, 'Feb' => 2, 'Mar' => 3, 'Apr' => 4,
               'May' => 5, 'Jun' => 6, 'Jul' => 7, 'Aug' => 8,
               'Sep' => 9, 'Oct' => 10, 'Nov' => 11, 'Dec' => 12 }
    months[str]
  end

  def positive_attitude?(string)
    [":)", "=)", ":-)", ":D"].any? { |emoticon| string.include?(emoticon) }
  end

  def negative_attitude?(string)
    [":(", "=(", ":-(", ":P"].any? { |emoticon| string.include?(emoticon) }
  end

  def hyperlinks?(str)
    str.include?('http://') || str.include?('https://')
  end
end
