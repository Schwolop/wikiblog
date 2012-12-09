require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    before do
      visit '/home'
      @home_page_content = page.text
    end
    
    it "should have some content" do
      @home_page_content.should have_content('WikiBlog')
    end
    
    it "should be accessible via the root url" do
      visit '/'
      page.text.should eq(@home_page_content)
    end
  end
  
  describe "About page" do
    it "should have some content" do
      visit '/about'
      page.should have_content('WikiBlog')
    end
  end
end