require 'spec_helper'

describe "User pages" do

  	subject { page }

  	# Checks that the sign up page is correct and present
  	describe "signup page" do
	    before { visit signup_path }

	    it { should have_content('Sign up') }
	    it { should have_title(full_title('Sign up')) }
	end

	# Checks that showing the user works
	describe "profile page" do
		# Make a user variable  so that show will have something to find. We
		# use FactoryGirl to do this where the declaration of the :user symb
		# as a User model object is done. This is a user factor
		let(:user) { FactoryGirl.create(:user) }
		# This vistsis the path wit hthe givin user. 
		before { visit user_path(user) }

		# make sure this is the right user by checking the names match up 
		it { should have_content(user.name) } 
		it { should have_title(user.name) }
	end

	describe "signup" do
		# Visit the path to sign up for an account
	    before { visit signup_path }

	    # The text for the submission button
	    let(:submit) { "Create my account" }

	    describe "with invalid information" do
			it "should not create a user" do
				# click_button clicks the button with the given text
				expect { click_button submit }.not_to change(User, :count)
			end
	    end

	    describe "with valid information" do
			before do
				# This fills in the form fields with the given name and 
				# information
				fill_in "Name",         with: "Example User"
				fill_in "Email",        with: "user@example.com"
				fill_in "Password",     with: "foobar"
				fill_in "Confirmation", with: "foobar"
			end

			it "should create a user" do
				# We want the number of users to change from 0 to 1 when we 
				# create a new user so we must check for that. User.count
				# is a method which returns the number of user method objects.
				# The reason we use expect is because it needs to calculate 
				# the number beofre and after the execution 
				expect { click_button submit }.to change(User, :count).by(1)
			end
	    end
  end
end