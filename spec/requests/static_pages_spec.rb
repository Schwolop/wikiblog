require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have some content" do
      visit '/static_pages/home'
      page.should have_content('WikiBlog')
    end
  end
  
  describe "About page" do

    it "should have some content" do
      visit '/static_pages/about'
      page.should have_content('WikiBlog')
    end
  end
end