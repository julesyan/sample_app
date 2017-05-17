class Relationship < ActiveRecord::Base
	# followed_users -> users who are followed by the given user
	# followers -> users who follow the current user


	# A relationshipp object belongs to both a follower and a followed user
	# We supply class names because we have no models called Foolowed and 
	# followers since those are the default models it looks for
	belongs_to :follower, class_name: "User"
	belongs_to :followed, class_name: "User"

	# These two need to be present in order for the relationship to be valid
  	validates :follower_id, presence: true
  	validates :followed_id, presence: true
end
