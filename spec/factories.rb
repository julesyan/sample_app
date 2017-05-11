# this file automatically gets loaded when running the spec tests
FactoryGirl.define do
	# We pass the :user symbol to hte factory command which tels FactoryGirl
	# that it is a definition of a User model object
	factory :user do
		name		"Michael Hartl"
		email		"michael@example.com"
		password	"foobar"
		password_confirmation	"foobar"
	end
end