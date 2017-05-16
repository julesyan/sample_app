require 'spec_helper'

describe Micropost do
  # Create a user we can run tests on
  let(:user) { FactoryGirl.create(:user) }
  #before do
    # This code is not idiomatically correct.
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  #end

  # This is used instead because we have build function due to a micropost
  # being associated with a user (a user has many microposts and a micropost
  # belongs to a user)
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }

  # Because micropost.user shold return the micropsot's user we test if it
  # responds and returns the correct value
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end

  # Mae sure we always have micropsots with content and should be invalid 
  # if we have blank psots
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end

  # Make sure the content of the psots are no longer thant 140 char
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end
