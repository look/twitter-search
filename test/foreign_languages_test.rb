require File.join(File.dirname(__FILE__), 'test_helper')

class ForeignLanguagesTest < Test::Unit::TestCase # :nodoc:
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
end
