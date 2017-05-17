require 'spec_helper'

# Tests that require authentication and actions that needs certain 
# authentication before hand before performing an action 
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
			#before { valid_signin(user) }

			# Uses a sign_in function for tests
			before { sign_in user }

			# This is what should appear on the page after signing in 
			it { should have_title(user.name) }
			# have_link takes the text of hte link and the URL as href. This 
			# function makes sure that the given line exists in the result 
			# page and that it links to the correct URLs
			it { should have_link('Users',       href: users_path) }
			it { should have_link('Profile',     href: user_path(user)) }
      		it { should have_link('Settings',    href: edit_user_path(user)) }
			it { should have_link('Sign out',    href: signout_path) }
			it { should_not have_link('Sign in', href: signin_path) }

			# We now need ot test signing out which happens after a sign in
			describe "folloes by a signout" do
				before { click_link "Sign out" }
				it { should have_link('Sign in') }
			end
    	end
  	end

  	describe "authorization" do

	    describe "for non-signed-in users" do
	    	let(:user) { FactoryGirl.create(:user) }

	    	# If visiting edit or update
			describe "when attempting to visit a protected page" do
				# Go to the edit page which should redirect ot sign in and 
				# then sign in with corect informaiton
				before do
					visit edit_user_path(user)
					fill_in "Email",    with: user.email
					fill_in "Password", with: user.password
					click_button "Sign in"
				end

				# We should now see the edit page for the new signed in user
				describe "after signing in" do
					it "should render the desired protected page" do
						expect(page).to have_title('Edit user')
					end
				end
			end

	    	describe "in the Users controller" do
		      	# Visit the edit page to make sure it redirects to sign in if we are
		      	# not signed in
		        describe "visiting the edit page" do
		          before { visit edit_user_path(user) }
		          it { should have_title('Sign in') }
		        end

		        # If we submit an update make sure we go back to sign in since we are
		        # not signed in to compelte this action
		        describe "submitting to the update action" do
		        	# Issues a pathc request to access a controlelr aciton
		        	# issues request to /users/# which goes to the update action of
		        	# the controller. 
		        	# Note: to get ot an update we need to submit a form so we have
		        	# 		to get there indirectly (because going through the edit
		        	# 		page would need authorization) so we submit a direct 
					# 		request
					before { patch user_path(user) }
					specify { expect(response).to redirect_to(signin_path) }
		        end

		        # We test that index action is protected and goe to sign in 
		        # page if not signed in 
		        describe "visiting the user index" do
					before { visit users_path }
					it { should have_title('Sign in') }
				end

				describe "visiting the following page" do
		          before { visit following_user_path(user) }
		          it { should have_title('Sign in') }
		        end

		        describe "visiting the followers page" do
		          before { visit followers_user_path(user) }
		          it { should have_title('Sign in') }
		        end
		    end

		    # If we are no signed in, then we should not be allowed to create
		    # posts for the user
		    describe "in the Microposts controller" do
				describe "submitting to the create action" do
					before { post microposts_path }
					specify { expect(response).to redirect_to(signin_path) }
				end

				describe "submitting to the destroy action" do
					before { delete micropost_path(FactoryGirl.create(:micropost)) }
					specify { expect(response).to redirect_to(signin_path) }
				end
			end


			describe "in the Relationships controller" do
		        describe "submitting to the create action" do
		          before { post relationships_path }
		          specify { expect(response).to redirect_to(signin_path) }
		        end

		        describe "submitting to the destroy action" do
		          before { delete relationship_path(1) }
		          specify { expect(response).to redirect_to(signin_path) }
	        end
      		end
    	end

    	# Checking we can only edit hte pages of a correct user
    	describe "as wrong user" do
			let(:user) { FactoryGirl.create(:user) }
			# we are now creating a second user who is the same same as the 
			# first but with an incorect email
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
			
			# we are setting capybara to true so we can get the GET and PATCH
			# methods to hit hte edit and update directyl
			# sign in with the correct user
			before { sign_in user, no_capybara: true }

			# goes to the edit page with the wrong user as the parameters and
			# the original user should not have access to the second user's pg 
			describe "submitting a GET request to the Users#edit action" do
				before { get edit_user_path(wrong_user) }
				specify { expect(response.body).not_to match(full_title('Edit user')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			# goes to the udpate page as the wrong user and should redirect
			describe "submitting a PATCH request to the Users#update action" do
				before { patch user_path(wrong_user) }
				specify { expect(response).to redirect_to(root_url) }
			end
   		end

   		# If user is not an admin they shoudl not be able to delet anyone
   		describe "as non-admin user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before { sign_in non_admin, no_capybara: true }

			describe "submitting a DELETE request to the Users#destroy action" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
			end
    	end
  	end
end
