require File.join(File.dirname(__FILE__), 'test_helper')

class PaginationTest < Test::Unit::TestCase # :nodoc:
  context "@client.query :q => 'Boston Celtics', :rpp => '30'" do
    setup do
      @tweets = read_yaml :file => 'results_per_page'
    end

    should_find_tweets
    should_have_text_for_all_tweets
    should_return_page 1
    should_return_tweets_in_sets_of 30
  end

  context "@client.query :q => 'a Google(or Twitter)whack', :rpp => '2'" do
    setup do
      @tweets = read_yaml :file => 'only_one_result'
    end

    should 'not be able to get next page of @tweets' do
      assert ! @tweets.has_next_page?
    end
  end

  context "@client.query :q => 'almost Google(or Twitter)whack', :rpp => '1'" do
    setup do
      @page_one = read_yaml :file => 'only_two_results'
      @page_two = read_yaml :file => 'only_two_results_page_2'
    end

    should 'be able to get next page of @tweets' do
      assert @page_one.has_next_page?

      FakeWeb.register_uri( :get,
                            "#{TwitterSearch::Client::TWITTER_SEARCH_API_URL}?max_id=100&q=almost+a+Google%28or+is+it+Twitter%29whack&rpp=1&page=2",
                            :body => '{"results":[{"text":"Boston Celtics-Los Angeles Lakers, Halftime http://tinyurl.com/673s24","from_user":"nbatube","id":858836387,"language":"en","created_at":"Tue, 15 Jul 2008 09:27:57 +0000"}],"since_id":0,"max_id":100,"results_per_page":1,"page":2,"query":"almost+a+Google%28or+is+it+Twitter%29whack"}'
                          )
      next_page = @page_one.get_next_page
      assert_equal @page_two[0].created_at, next_page[0].created_at
      assert_equal @page_two[0].text,       next_page[0].text
    end
  end
end
