require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "login page" do
    before { visit login_path }

    it { should have_selector('h1',    text: 'Log in') }
  end

  describe "logging in" do
    before { visit login_path }
    
    describe "with invalid information" do
      before { click_button "Log in" }

      it { should have_selector('h1', text: 'Log in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Log in"
      end

      it { should have_selector('title', text: user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Log out', href: logout_path) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should_not have_link('Log in', href: login_path) }
      
      describe "followed by log out" do
        before { click_link "Log out" }
        it { should have_link('Log in') }
      end
    end
  end
  
  describe "authorization" do
    describe "for non-logged-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Log in"
        end

        describe "after logging in" do

          it "should render the desired protected page" do
            page.should have_selector('h1', text: 'Update your profile')
          end
        end
      end

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('h1', text: 'Log in') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(login_path) }
        end
      end
    end
    
    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { log_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('h1', 'Edit user') }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end
  end
end