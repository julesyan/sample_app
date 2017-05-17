class CreateRelationships < ActiveRecord::Migration
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id

      t.timestamps
    end
    # Addign indexes for efficency
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    # This means that you cant have more than one (follower_id, followed_id)
    # pair so that we can't follow the same person twice
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
