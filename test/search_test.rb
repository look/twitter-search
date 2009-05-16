require File.join(File.dirname(__FILE__), 'test_helper')

class SearchTest < Test::Unit::TestCase # :nodoc:
  context "@client.query 'Obama'" do
    setup do
      @tweets = read_yaml :file => 'obama'
    end

    should_have_default_search_behaviors

    should 'find tweets containing the single word "Obama"' do
      assert @tweets.all? { |tweet| tweet.text =~ /obama/i }
    end
  end

  context "@client.query 'twitter search'" do
    setup do
      @tweets = read_yaml :file => 'twitter_search'
    end

    should_have_default_search_behaviors

    should 'find tweets containing both "twitter" and "search"' do
      assert @tweets.all?{ |t| t.text =~ /twitter/i && t.text =~ /search/i }
    end
  end

  context "@client.query :q => 'twitter search'" do
    setup do
      @tweets = read_yaml :file => 'twitter_search_and'
    end

    should_have_default_search_behaviors

    should 'find tweets containing both "twitter" and "search"' do
      assert @tweets.all?{ |t| t.text =~ /twitter/i && t.text =~ /search/i }
    end
  end
end
