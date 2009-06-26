require File.join(File.dirname(__FILE__), 'test_helper')

class HashInterfaceTest < Test::Unit::TestCase # :nodoc:
  def setup
    @tweets = read_yaml :file => 'reference_mashable'
  end

  context "@tweets[2]" do
    should_have_default_search_behaviors

    should 'return the third tweet' do
      assert_equal 859152168, @tweets[2].id
    end
  end

  context "TwitterSearch::Tweets#pop" do
    should "return the last element of the results and reduce the size by 1" do
      size = @tweets.size
      last = @tweets.pop
      assert_equal 858878458, last.id
      assert_equal size-1, @tweets.size
    end
  end

  context "TwitterSearch::Tweets#empty?" do
    should "return false if there are tweets in the results" do
      assert !@tweets.empty?
    end

    should "return true if there no tweets in the results" do
      @tweets = read_yaml :file => 'no_results'

      assert @tweets.empty?
    end
  end

end
