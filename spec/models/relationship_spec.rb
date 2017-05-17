require 'spec_helper'

describe Relationship do
  # Create two users. One that is a follower to a user and that user is followed
  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }

  # Create a relationship between the follower nad hte followedw
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }

  subject { relationship }

  it { should be_valid }

  # Testing the belongs_to relattionship between users
  # get the follower and the followed of two users 
  describe "follower methods" do
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should eq follower }
    its(:followed) { should eq followed }
  end

  # When there is no folloed id it should not be a valid relationship
  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  # When there is no follower id there shoudl not be a valid relationship
  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
end
