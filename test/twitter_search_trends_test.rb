# coding: utf-8
require File.join(File.dirname(__FILE__), 'test_helper')
require 'fake_web'

FakeWeb.allow_net_connect = false # an insurance policy against hitting http://twitter.com

class TwitterSearchTrendsTest < Test::Unit::TestCase # :nodoc:
  context "@client.trends" do
    setup do
      @trends = read_yaml :file => 'trends'
    end
    
    should 'find a single trend' do
      assert_equal 1, @trends.size
    end
  end
end