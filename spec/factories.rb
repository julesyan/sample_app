# this file automatically gets loaded when running the spec tests
#FactoryGirl.define do
	# We pass the :user symbol to hte factory command which tels FactoryGirl
	# that it is a definition of a User model object
	#factory :user do
		#name		"Michael Hartl"
		#email		"michael@example.com"
		#password	"foobar"
		#password_confirmation	"foobar"
	#end
#end

#FactoryGirl.define do
  #factory :user do
    #sequence(:name)  { |n| "Person #{n}" }
    #sequence(:email) { |n| "person_#{n}@example.com"}
    #password "foobar"
    #password_confirmation "foobar"
  #end
#end

FactoryGirl.define do
  # Create a user
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  # Create a micropost, used:
  #   FactoryGirl.create(:micropsot, user: @user, created_at: <some date>)
  # Reminder: time is done by #.day.ago or #.hour.ago etc
  # We create the times manually (active REcord doesn't allow this since it
  # sets it themselves)
  factory :micropost do
    content "Lorem ipsum"
    user
  end
end