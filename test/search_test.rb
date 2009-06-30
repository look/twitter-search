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
  
  context "a complicated search that results in a 404" do
    setup do
      uri = "http://search.twitter.com/search.json?q=rails+-from%3Adhh+from%3Alof&since_id=1791298088"
      FakeWeb.register_uri(:get, uri, :response => File.here / 'responses' / 'complicated_search_404', :status => [404, "Not Found"])
    end
    
    should "raise a SearchServerError" do
      assert_raise TwitterSearch::SearchServerError do
        client = TwitterSearch::Client.new
        client.query :q => 'rails -from:dhh from:lof', :since_id => 1791298088
      end
    end
  end

  context "a search that returns a 200 but an unparsable body" do
    setup do
      uri = "http://search.twitter.com/search.json?rpp=100&q=ftc&since_id=2147483647&page=16"
      FakeWeb.register_uri(:get, uri, :response => File.here / 'responses' / 'error_page_parameter_403', :status => [403, "Forbidden"])
    end

    should "raise a SearchServerError" do
      assert_raise TwitterSearch::SearchServerError do
        client = TwitterSearch::Client.new
        client.query :q => 'ftc', :rpp => '100', :since_id => '2147483647', :page => '16'
      end
    end
  end
end
