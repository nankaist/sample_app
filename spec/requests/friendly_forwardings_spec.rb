require 'spec_helper'

describe "FriendlyForwardings" do
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    # The test auto follows the redirect to the signin page, aka, after click_button it in the signin page not the user page.
    fill_in :email, :with => user.email
    fill_in :password, :with => user.password
    click_button
    # the test follows the redirect again, this time to users/edit page
    response.should render_template('users/edit') #Attn:!! test follow the redirect to new pages, so we can't use .should redirect_to ..URL to test
  end
end
