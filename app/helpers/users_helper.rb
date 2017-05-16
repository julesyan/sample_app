module UsersHelper
	# Returns the Gravatar (http://gravatar.com/) for the given user.
	#def gravatar_for(user)
		# Gravatar uses a MD5 hash which is all lowercase, so we must make 
		# sure the value is downcase 
		#gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		#gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"
		# This function returns a html img tag with class gravatar with an 
		# alternate text of the user's name
		#image_tag(gravatar_url, alt: user.name, class: "gravatar")
	#end
	def gravatar_for(user, options = { size: 50 })
		gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
		size = options[:size]
		gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
		image_tag(gravatar_url, alt: user.name, class: "gravatar")
	end
end
