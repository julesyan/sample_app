class User < ActiveRecord::Base
	# Makes the email all lower case before saving to the database because
	# not all databases use case sensitive indices. This function is a spcial
	# callback function that is caleld during a certain point in the record
	before_save { self.email = email.downcase }

	# Below is the regex for a valid email. The variable is a constant (is all
	# caps). The grouping of (?:\.[a-z\d\-]+)* has ? which means 0 or one of
	# the dot then one or more of any character (that is not a dot) within 
	# the group where th group matches one or more times
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i

	# Function which validates the precense of the attributes, presence is an
	# optional hash. Must pass this validation if we want to save this object.
	# Also .valid? will return the value of this function (i.e. if the value
	# exists or not in the object). It validates the attribute using the blank
	# method for strings
	#
	# The legnth symbol validates that the length is below the max
	#
	# The format symbol validates that the input is of a certain format that
	# follows the regex indicated
	#
	# Uniqueness needs to  be true, but it also needs to not be case sensitive
	# which Rails has a option for which is implmented below. This can cause
	# issues if is submitted mroe then once quickly in succession and it will
	# create two records of the exact same information because they are never 
	# comapred to each other. This can be fixed with enforcing this validation
	# on the database level by creating an email index and making sure it is
	# unique. Index also lets comparison easier because we dont have to compare
	# every single email 
	validates :name, presence: true, length: { maximum: 50 }
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, 
						uniqueness: { case_sensitive: false }

	###############Making Our Own Authentication###############
	# Validation and length are automatically added in has_secure_password. If
	# there is a password_digest column then using has_secure_password is
	validates :password, length: { minimum: 6 }

	# Make sure that he password is secure by using a hashing function (this
	# function below does too much so we will not be using it, but can be used)
	has_secure_password
	###########################################################
end
