# coding: utf-8

require File.join(File.dirname(__FILE__), 'test_helper')


require 'fake_web'

FakeWeb.allow_net_connect = false # an insurance policy against hitting http://twitter.com


class TwitterSearchTest < Test::Unit::TestCase # :nodoc:

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
  
  # TWITTER SEARCH OPERATORS
  
  context '@client.query :q => \'"happy hour"\'' do
    setup do
      @tweets = read_yaml :file => 'happy_hour_exact'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing the exact phrase "happy hour"' do
      assert @tweets.all?{ |t| t.text =~ /happy hour/i }
    end
  end
  
  context "@client.query :q => 'obama OR hillary'" do
    setup do
      @tweets = read_yaml :file => 'obama_or_hillary'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing either "obama" or "hillary" (or both)' do
      assert @tweets.all?{ |t| t.text =~ /obama/i || t.text =~ /hillary/i }
    end
  end
  
  context "@client.query :q => 'beer -root'" do
    setup do
      @tweets = read_yaml :file => 'beer_minus_root'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "beer" but not "root"' do
      assert @tweets.all?{ |t| t.text =~ /beer/i || t.text !~ /root/i }
    end
  end
  
  context "@client.query :q => '#haiku'" do
    setup do
      @tweets = read_yaml :file => 'hashtag_haiku'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing the hashtag "haiku"' do
      assert @tweets.all?{ |t| t.text =~ /#haiku/i }
    end
  end
  
  context "@client.query :q => 'from: alexiskold'" do
    setup do
      @tweets = read_yaml :file => 'from_alexiskold'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets sent from person "alexiskold"' do
      assert @tweets.all?{ |t| t.from_user == 'alexiskold' }
    end
  end
  
  context "@client.query :q => 'to:techcrunch'" do
    setup do
      @tweets = read_yaml :file => 'to_techcrunch'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets sent to person "techcrunch"' do
      assert @tweets.all?{ |t| t.text =~ /^@techcrunch/i }
    end
  end
  
  context "@client.query :q => '@mashable'" do
    setup do
      @tweets = read_yaml :file => 'reference_mashable'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets referencing person "mashable"' do
      assert @tweets.all?{ |t| t.text =~ /@mashable/i }
    end
  end
  
  context "@client.query :q => '\"happy hour\" near:\"san francisco\"'" do
    setup do
      @tweets = read_yaml :file => 'happy_hour_near_sf'
    end
    
    # The Twitter Search API makes you use the geocode parameter for location searching
    should 'not find tweets using the near operator' do
      assert ! @tweets.any?
    end
  end
  
  context "@client.query :q => 'near:NYC within:15mi'" do
    setup do
      @tweets = read_yaml :file => 'within_15mi_nyc'
    end
    
    # The Twitter Search API makes you use the geocode parameter for location searching
    should 'not find tweets using the near operator' do
      assert ! @tweets.any?
    end
  end
  
  context "@client.query :q => 'superhero since:2008-05-01'" do
    setup do
      @tweets = read_yaml :file => 'superhero_since'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "superhero" and sent since date "2008-05-01" (year-month-day)' do
      assert @tweets.all?{ |t| t.text =~ /superhero/i && convert_date(t.created_at) > DateTime.new(2008, 5, 1) }
    end
  end
  
  context "@client.query :q => 'ftw until:2008-05-03'" do
    setup do
      @tweets = read_yaml :file => 'ftw_until'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "ftw" and sent up to date "2008-05-03"' do
      assert @tweets.all?{ |t| t.text =~ /ftw/i && convert_date(t.created_at) < DateTime.new(2008, 5, 3, 11, 59) }
    end
  end
  
  context "@client.query :q => 'movie -scary :)'" do
    setup do
      @tweets = read_yaml :file => 'movie_positive_tude'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "movie", but not "scary", and with a positive attitude' do
      assert @tweets.all?{ |t| t.text =~ /movie/i && t.text !~ /scary/i && positive_attitude?(t.text) }
    end
  end
  
  context "@client.query :q => 'flight :('" do
    setup do
      @tweets = read_yaml :file => 'flight_negative_tude'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "flight" and with a negative attitude' do
      assert @tweets.all?{ |t| t.text =~ /flight/i && negative_attitude?(t.text) }
    end
  end
  
  context "@client.query :q => 'traffic ?'" do
    setup do
      @tweets = read_yaml :file => 'traffic_question'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "traffic" and asking a question' do
      assert @tweets.all?{ |t| t.text =~ /traffic/i && t.text.include?('?') }
    end
  end
  
  context "@client.query :q => 'hilarious filter:links'" do
    setup do
      @tweets = read_yaml :file => 'hilarious_links'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "hilarious" and linking to URLs' do
      assert @tweets.all?{ |t| t.text =~ /hilarious/i && hyperlinks?(t.text) }
    end
  end
  
  # USER AGENT
  
  context "A new Client instance" do
    setup do
      @client = TwitterSearch::Client.new
    end
    
    should 'respond to user agent' do
      assert_respond_to @client, :agent
    end
    
    should 'set a default user agent' do
      assert_equal @client.headers['User-Agent'], "twitter-search"
      assert_equal @client.agent, "twitter-search"
    end
    
    should 'set a default timeout for the http request' do
      assert_equal @client.timeout, TwitterSearch::Client::TWITTER_API_DEFAULT_TIMEOUT
    end
  end
  
  # FOREIGN LANGUAGES
  
  context "@client.query :q => 'congratulations', :lang => 'en'" do
    setup do
      @tweets = read_yaml :file => 'english'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "congratulations" and are in English' do
      assert @tweets.all?{ |t| t.text =~ /congratulation/i && t.language == 'en' }
    end
  end
  
  context "@client.query :q => 'با', :lang => 'ar'" do
    setup do
      @tweets = read_yaml :file => 'arabic'
    end
    
    should_have_default_search_behaviors
    
    should 'find tweets containing "با" and are in Arabic' do
      assert @tweets.all?{ |t| t.text.include?('با') && t.language == 'ar' }
    end
  end

  # PAGINATION
  
  context "@client.query :q => 'Boston Celtics', :rpp => '30'" do
    setup do
      @tweets = read_yaml :file => 'results_per_page'
    end


    should_find_tweets
    should_have_text_for_all_tweets
    should_return_page 1
    should_return_tweets_in_sets_of 30
  end

  context "@client.query :q => 'a Google(or is it Twitter)whack', :rpp => '2'" do
    setup do
      @tweets = read_yaml :file => 'only_one_result'
    end

    should 'not be able to get next page of @tweets' do
      assert ! @tweets.has_next_page?
      #assert_raise Exception, @tweets.next_page
    end
  end

  context "@client.query :q => 'almost a Google(or is it Twitter)whack', :rpp => '1'" do
    setup do
      @tweets = read_yaml :file => 'only_two_results'
      @next_page_of_tweets = read_yaml :file => 'only_two_results_page_2'
    end

    should 'be able to get next page of @tweets' do
      assert @tweets.has_next_page?

      FakeWeb.register_uri( :get,
                            "#{TwitterSearch::Client::TWITTER_API_URL}?max_id=100&q=almost+a+Google%28or+is+it+Twitter%29whack&rpp=1&page=2",
                            :string => '{"results":[{"text":"Boston Celtics-Los Angeles Lakers, Halftime http://tinyurl.com/673s24","from_user":"nbatube","id":858836387,"language":"en","created_at":"Tue, 15 Jul 2008 09:27:57 +0000"}],"since_id":0,"max_id":100,"results_per_page":1,"page":2,"query":"almost+a+Google%28or+is+it+Twitter%29whack"}'
                          )
      next_page = @tweets.get_next_page
      # It's hard to muck around with objects' .id fields in Ruby, so check other fields instead:
      assert_equal @next_page_of_tweets[0].created_at, next_page[0].created_at
      assert_equal @next_page_of_tweets[0].text, next_page[0].text
    end
  end


  # HELPERS
  
  context "@tweets[2]" do
    setup do
      @tweets = read_yaml :file => 'reference_mashable'
    end
    
    should_have_default_search_behaviors
    
    should 'return the third tweet' do
      assert_equal 859152168, @tweets[2].id
    end
  end

  protected
  
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
  
    def positive_attitude?(str)
      str.include?(':)') || str.include?('=)') || str.include?(':-)') || str.include?(':D')
    end
    
    def negative_attitude?(str)
      str.include?(':(') || str.include?('=(') || str.include?(':-(') || str.include?(':P')
    end
    
    def hyperlinks?(str)
      str.include?('http://') || str.include?('https://')
    end
  
    def read_yaml(opts = {})
      return if opts[:file].nil?
      YAML.load_file File.join(File.dirname(__FILE__), 'yaml', "#{opts[:file]}.yaml") 
    end
  
end
