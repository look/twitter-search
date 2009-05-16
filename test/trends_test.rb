require File.join(File.dirname(__FILE__), 'test_helper')

class TrendsTest < Test::Unit::TestCase # :nodoc:
  context "@client.trends" do
    setup do
      @trends = read_yaml :file => 'trends'
    end

    should 'find a single trend' do
      assert_equal 1, @trends.size
    end
  end
end
