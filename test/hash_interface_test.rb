require File.join(File.dirname(__FILE__), 'test_helper')

class HashInterfaceTest < Test::Unit::TestCase # :nodoc:
  context "@tweets[2]" do
    setup do
      @tweets = read_yaml :file => 'reference_mashable'
    end

    should_have_default_search_behaviors

    should 'return the third tweet' do
      assert_equal 859152168, @tweets[2].id
    end
  end
end
