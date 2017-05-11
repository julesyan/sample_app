class UsersController < ApplicationController
	def show
		# This will grab the user with the given id where the id is supplied
		# through there parametres of the link. This is the same as 
		# using User.find(#) since params[:id] is the # value, find converts
		# it to an int for us
		@user = User.find(params[:id])
	end

	def new
		# We must create a new one so that we can create a new user in 
		# the new.html.erb, otherwise will not be able to be used
		@user = User.new
	end

	# Since we are using the REST URLs then this will be called when creating
	# a new user with the POST request (the form knows to send as /users with
	# POST)
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
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	# This will only allow certain parameters of the params to go through 
	private 
	def user_params
		params.require(:user).permit(:name, :email, :password, 
									 :password_confirmation)
	end
end
