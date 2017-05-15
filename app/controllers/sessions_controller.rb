class SessionsController < ApplicationController
	# Is what is used for sign in to a page
	def new
  	end

  	# When signing in, this is what is run when hitting the Sign In btn.
  	# Populated params with a nested hash which has a :session which is a hash
  	# Note: params[:session] is a hash with the field input. Is then accessed
  	# 		by params[:session][:attribute]
	def create
		# We will find the user given the information from params (remember
		# we downcase the email because it is case insensitive)
		user = User.find_by(email: params[:session][:email].downcase)
		
		if user && user.authenticate(params[:session][:password])
			# If there is an existing user and it is the proper password, go to 
			# the user's page. Reminder: authenticate returns true if it passed
			# Plan: when successfully signing in, we call the sign_in function
			# 		and  then redirect to their profile page
			sign_in user
			redirect_to user
		else
			# Otherwise we must show an error message and rerender the sign in 
			# form for them to retry (Bootstrap gives the error message nice
			# styling because we give it symbol error). This flash msg will
			# be displayed for one request longer hten neede because of the use
			# of render and it not submitted a request (so flash is redispalyed)
			# Using flash.now fixes this. The contents of this flash 
			# dissapppear when there is another request
			flash.now[:error] = 'Invalid email/password combination'
			# Goes to the new.html.erb for this controller which is the 
			# URL /sessions/new with blanks fields
			render 'new'
		end
	end

	# Used to delete a session, aka sign out. We will use another method 
	# similar to that of sign in. Will then take the user back ot hte home pg
	def destroy
		sign_out
		redirect_to root_url
	end

end
