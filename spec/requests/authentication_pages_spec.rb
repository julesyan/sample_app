require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do
		before { visit signin_path }

		it { should have_content('Sign in') }
		it { should have_title('Sign in') }
	end

	describe "signin" do
	    before { visit signin_path }

	    # This test will check to see what happens when we give the form 
	    # invalid informaiton
	    describe "with invalid information" do
			before { click_button "Sign in" }

			it { should have_title('Sign in') }
			# Checks for a certain HTML tag (visable elements). This one 
			# checks for a div tag with class alert and alert-error. The 
			# dot indicates a class where a # indicates a id
			it { should have_selector('div.alert.alert-error') }

			# The flash msg should be dissappear after moving to a new page.
			# So we will check to see if the flash message is still present 
			# when we move to a new page
			describe "after visiting another page" do
				before { click_link "Home" }
				it { should_not have_selector('div.alert.alert-error') }
			end
	    end

	    # This test will check to see results when given valid informaiton
	    # into the sign in page
	    describe "with valid information" do
	    	# Create a user that was defined in spec/factories.rb
			let(:user) { FactoryGirl.create(:user) }

			# Fill in the form initally with information so that we can see
			# what happens with valid information (this user shoudl be already
			# in the database since we used .create). fill_in is a function 
			# which fills in the form fields iwth the given information
			#before do
				# This is upcased because the email is case insensitive 
				#fill_in "Email",    with: user.email.upcase
				#fill_in "Password", with: user.password
				#click_button "Sign in"
			#end
			before { valid_signin(user) }

			# This is what should appear on the page after signing in 
			it { should have_title(user.name) }
			# have_link takes the text of hte link and the URL as href. This 
			# function makes sure that the given line exists in the result 
			# page and that it links to the correct URLs
			it { should have_link('Profile',     href: user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			# We now need ot test signing out which happens after a sign in
			describe "folloes by a signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
    end
  	end
end
