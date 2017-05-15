module SessionsHelper
	# This method creates a new token then places the token in the user's 
	# browser as a cookie, then hash the token and store it in the database.
	# We also save the current_user as the user given since this function can
	# be used without a redirect
	def sign_in(user)
		# Create a new token
	    remember_token = User.new_remember_token

	    # Save the token to the user's browser as a permanent cookie. cookies
	    # allows use to use the broser's bookies as a hash where each cookie
	    # is a hash (is nested hashes) with attributes value and expires (so 
	    # that the cookie can expire if needed). .permanent sets the expiry
		# to 20 yrs from now. Rails has time helpers which allow us to find
		# things such as 20.years.from_now.utc - which returns the date 20 yrs
		# from now
	    cookies.permanent[:remember_token] = remember_token

	    # Hash the token and save it in the database. We use update_attribute
	    # which udpates the given attribute and bypasses any validation which
	    # is useful if we don't have a user's password
	    user.update_attribute(:remember_token, User.digest(remember_token))

	    # Make sure to set the current_user in case it is not already set
	    self.current_user = user
	end

	# Returns if there exists a current user 
	def signed_in?
		!current_user.nil?
	end

	# This definition assignes the given uesr to the current user (which is a
	# instance variable)
	def current_user= (user)
		@current_user = user
	end

	# Ordinarily we would have this definition jsut return the value of 
	# @current_user which would reset this variable to nil when the user 
	# switches pages
	def current_user
		# We hash the token from the user because we have it hashed in the 
		# database
	    remember_token = User.digest(cookies[:remember_token])
	    # If the user is undefined, then get the user and store it (same as if
	    # we did @user = @user || "soemthing" where it takes the one that is
	    # not nil)
	    @current_user ||= User.find_by(remember_token: remember_token)
	 end

	# To sign a user out, first we change the token (because the cookie could
	# have been stolen and can currently still be used to authorize someone),
	# then we use the delete function to delete the cookie from the user's 
	# browser. We set current user to nil as  there is no current user anymore
	def sign_out
		# Here we are changing the token in the database to a new one so that
		# you can't use the old token to sign a user in
		current_user.update_attribute(:remember_token, 
			User.digest(User.new_remember_token))
		# Remove the cookie from the browser
		cookies.delete(:remember_token)
		self.current_user = nil
	end
end
