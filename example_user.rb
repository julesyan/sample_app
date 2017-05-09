class User
	# Create attribute acessors - creates getter and setters for  those two 
	# variables (@name and @email are instance variables). These are accessed
	# by using the @ symbol and are nil when unassigned
	attr_accessor :name, :email

	# This function is what is called when creating a new object, this one 
	# takes one argument. The argument here has a default value of an empty 
	# hash in case nothing is given in so that we can assign nil if needed
	def initialise(attributes = {})
		@name = attributes[:name]
		@email = attributes[:email]
	end

	# This funciton formats the informaiton nicely using string interpolation
	def formatted_email
		"#{@name} <#{@email}>"
	end
end