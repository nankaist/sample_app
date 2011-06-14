require 'spec_helper'

describe PagesController do
  render_views #tell rspec to test not only the default actions but also the views

  describe "GET 'home'" do  #everything in " " are just descriptions for human, not for rspec
    it "should be successful" do
      get 'home'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'home'
      response.should have_selector("title",
              :content => "Ruby on Rails Tutorial Sample App | Home")
    end
    
  end

  describe "GET 'contact'" do
    it "should be successful" do
      get 'contact'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'contact'
      response.should have_selector("title",
              :content => "Ruby on Rails Tutorial Sample App | Contact")
    end
    
  end
  
  describe "GET 'about'" do
    it "should be successful" do
      get 'about'
      response.should be_success
    end
    
    it "should have the right title" do
      get 'about'
      response.should have_selector("title",
                :content => "Ruby on Rails Tutorial Sample App | About")
    end
    
  end
    
end
