require 'spec_helper'

describe "Users" do
  
  describe "signup" do
    describe "failure" do # sign up failure test
      it "should not make a new user" do
        lambda do
          visit signup_path
          fill_in "Name",   :with => '' #!Name is the label name for the field; for the field without label, use fill_in :user_name
          fill_in "Email",  :with => ''
          fill_in "Password", :with => ''
          fill_in "Confirmation", :with => ''
          click_button
          response.should render_template('users/new')
          response.should have_selector("div#error_explanation") # div#error_explanation is short for div id="error_explanation"
        end.should_not change(User, :count) # check failure of signup not change User :count
      end
    end
    
    describe "success" do
      it "should make a new user" do
        lambda do
          visit signup_path
          fill_in 'Name', :with => 'Test User'
          fill_in 'Email', :with => 'TestUser@gmail.com'
          fill_in 'Password', :with => 'foobar'
          fill_in 'Confirmation', :with => 'foobar'
          click_button
          response.should have_selector('div.flash.success', :content => "Welcome")
          response.should render_template('users/show')
        end.should change(User, :count).by(1)
      end
    end
  end
  
  
  # describe "GET /users" do
  #   it "works! (now write some real specs)" do
  #     # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
  #     get users_index_path
  #     response.status.should be(200)
  #   end
  # end
end