class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	# Adds an index to the email column to the users table and makes sure it
  	# is a unique 
  	add_index :users, :email, unique: true
  end
end
