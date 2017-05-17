class UsersController < ApplicationController
	# Before we go to edit and update we go through the filter
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy,
											:following, :followers]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy

	# Stores all the useres form the database in to @users
	def index
		#@users = User.all
		# We use hte oen below so that we can have pages
		@users = User.paginate(page: params[:page])
	end

	# This will delete a user given the id 
	def destroy
		User.find(params[:id]).destroy
		flash[:success] = "User deleted."
		redirect_to users_url
	end

	def show
		# This will grab the user with the given id where the id is supplied
		# through there parametres of the link. This is the same as 
		# using User.find(#) since params[:id] is the # value, find converts
		# it to an int for us
		@user = User.find(params[:id])

		# Gets the micrposts for this user
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		# We must create a new one so that we can create a new user in 
		# the new.html.erb, otherwise will not be able to be used
		@user = User.new
	end

	# Since we are using the REST URLs then this will be called when creating
	# a new user with the POST request (the form knows to send as /users with
	# POST). 
	def create 
		# Saves the new user model object created when submitting the form
		# and the name attribute of each input tag is the attributes to the
		# user model object. This line raises am error in Rails 4.0+. It is 
		# not used because it is not secure since it can be intercepted and 
		# flushed with bad data since it sends all the data submitted
		#@user = User.new(params[:user])
		@user = User.new(user_params)

		if @user.save
			# We saved successfully (save returns true if successful). Go to
			# the user's page
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	# This is accessed by /users/#/edit 
	# The id of the user (the #) is in params[:id]
	def edit
		# Sets the user to the current one (we want to omit that so that we
		# don't have to )
		#@user = User.find(params[:id])
	end

	# Need for tests to pass as it needs to call update
	def update
		# Get the user
		#@user = User.find(params[:id])
		# This allows us to show good error messages when we update our 
		# attributes for the given user
	    if @user.update_attributes(user_params)
	    	# Handle a successful update.
	    	# Successfully updated hte profile and redirect to the corerct page
	    	flash[:success] = "Profile updated"
      		redirect_to @user
	    else
	    	render 'edit'
	    end
	end

	def following
		@title = "Following"
		@user = User.find(params[:id])
		@users = @user.followed_users.paginate(page: params[:page])
		render 'show_follow'
	end

	def followers
		@title = "Followers"
		@user = User.find(params[:id])
		@users = @user.followers.paginate(page: params[:page])
		render 'show_follow'
	end


	# This will only allow certain parameters of the params to go through 
	private 
	def user_params
		params.require(:user).permit(:name, :email, :password, 
									 :password_confirmation)
	end

	############ Basic filters so that we go to correct pages

	# This is to redurect ot he sign in page if they are uncessful signing in
	############NOW IN THE HELPERS AS MANY CONTROLLERS NEED IT
	#def signed_in_user
		# redirect_to is a short form for setting flash[:notice] and then
		# redirecting ot hte given url. Notice is a yellow box
		# NOTE: this does not work fro :error or :success
		#store_location
    	#redirect_to signin_url, notice: "Please sign in." unless signed_in?
    #end

    # Checks that the user is the correct one that is isgned in 
    def correct_user
		@user = User.find(params[:id])
		redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
    	redirect_to(root_url) unless current_user.admin?
    end
end
