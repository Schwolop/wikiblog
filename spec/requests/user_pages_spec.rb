require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }
    it { should have_selector('h1',    text: 'Sign up') }

    let(:submit) { "Create an account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
      describe "after submission" do
        before { click_button submit }

        it { should have_selector('h1', text: 'Sign up') }
        it { should have_content('error') }
        end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "password"
        fill_in "Confirmation", with: "password"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        it { should have_link('Log out') }
      end
    end
    
    describe "edit" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        log_in user
        visit edit_user_path(user)
      end

      describe "page" do
        it { should have_selector('h1',    text: "Update your profile") }
        it { should have_link('Change your profile picture at Gravatar', href: 'http://gravatar.com/emails') }
      end

      describe "with invalid information" do
        before { click_button "Save changes" }

        it { should have_content('error') }
      end
      
      describe "with valid information" do
        let(:new_name)  { "New Name" }
        let(:new_email) { "new@example.com" }
        before do
          fill_in "Name",             with: new_name
          fill_in "Email",            with: new_email
          fill_in "Password",         with: user.password
          fill_in "Confirm Password", with: user.password
          click_button "Save changes"
        end

        it { should have_selector('title', text: new_name) }
        it { should have_selector('div.alert.alert-success') }
        it { should have_link('Log out', href: logout_path) }
        specify { user.reload.name.should  == new_name }
        specify { user.reload.email.should == new_email }
      end
    end

  end
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end
end