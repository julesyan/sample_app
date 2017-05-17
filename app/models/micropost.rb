class Micropost < ActiveRecord::Base
	# Create the association between micropost and user
	belongs_to :user

	# Sets the order of listing posts to be decending by created_at
	# This uses SQL to do this
	# This object is called a Proc (procedure) or lambda which is the ->
	# 	A Proc works by taking in a block then evaluates it's contents when
	# 	the called with the 'call' method (As in '-> { puts "foo" }.call' will
	# 	evaluate the block)
	default_scope -> { order('created_at DESC') }

	# Makes sure that there is a user_id present
	validates :user_id, presence: true

	# Makes sure the content in the post has content that is less than 140char
	validates :content, presence: true, length: { maximum: 140 }

	# Returns microposts from the users being followed by the given user.
	def self.from_users_followed_by(user)
		followed_user_ids = user.followed_user_ids
	    #where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
		where("user_id IN (:followed_user_ids) OR user_id = :user_id",
		      followed_user_ids: followed_user_ids, user_id: user)
	end
end
