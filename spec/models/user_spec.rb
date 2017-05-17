require 'spec_helper'

describe User do
  #Creates a new usre before it runs the test
  before { @user = User.new(name: "Example User", email: "user@example.com",
                   password: "foobar", password_confirmation: "foobar") }

  # Makes @user the subject of the testing so that we always test the object
  subject { @user }

  #Makes sure that these attributes are valid and are present 
  #Usually included so that we know what attributes the model can use
  #These methods use  the .respond_to? method
  # THese test of the existance of the attributes, not that they contain the
  # correct information
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it {should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  # This function will test to see if the user is following the other user
  it { should respond_to(:following?) }
  # This function will allow the user to follow the given user
  it { should respond_to(:follow!) }

  # Checking that the object @user is actually valid (and that we have not
  # forgotten anything). Any be_something will also respond with something?
  it { should be_valid } 
  it { should_not be_admin }

  # If we are an admin, check certain things
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  # Sets the name to be blank (invalid) and tests that the object is actually
  # set as invalid (checking htat validation is acutally working since if 
  # it's not then having a blank name would be valid)
  describe "when name is not present" do
  	before { @user.name = " " }
  	it {should_not be_valid }
  end

  # Check that the email validation is actually working
  describe "when email is not present" do
  	before { @user.email = " " }
  	it { should_not be_valid }
  end

  # Checking that the name can only be a maximum of 50 characters long
  describe "when name is too long" do
  	# This will create a name string with a written 51 times (an invalid length)
  	before { @user.name = "a" * 51 }
  	it { should_not be_valid }
  end

  # Checking that email validation is working
  describe "when email format is invalid" do
  	# Checkign that the email is invalid
  	it "should be invalid" do 
  		# The addresses listed below are invalid
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo. 
  			foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  		# Go though each of the addresses in the array created
  		addresses.each do |invalid_address|
  			@user.email = invalid_address
  			expect(@user).not_to be_valid
  		end
  	end
  end

  # Check that the email is valid when it should be
  describe "when email format is valid" do
    it "should be valid" do
    	# These are valid emails
    	addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      	addresses.each do |valid_address|
        	@user.email = valid_address
        	expect(@user).to be_valid
      end
    end
  end

  # Checking if the email was duplicated 
  describe "when emails address is already taken" do 
  	# Here we are duplicating the user and saving them to the database so 
  	# that we can properly validate uniqueness
  	before do
  		user_with_same_email = @user.dup
  		# We need to incorporate the fact that the validation should be case 
  		# insensitive so having them all uppercase will allow us to compare
  		user_with_same_email.email = @user.email.upcase
  		user_with_same_email.save
  	end

  	# We want the @user to be invalid because we already have a duplicate 
  	# of it from the before section
  	it { should_not be_valid }
  end

  # Exercise 6.5.1: testing that email is downcased
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    # Save the email and then comare it to the version in the database
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end

  # Check that hte password is present
  describe "when password is not present" do
  	# This will be run before this example ony
  	before do
  		@user = User.new(name: "Example User", email: "user@example.com",
                     password: " ", password_confirmation: " ")
  	end 
  	it { should_not be_valid }
  end

  # Check that hte password and the password confirmation do not match
  describe "when password doesn't match confirmation" do
  	before { @user.password_confirmation = "mismatch" }
  	it { should_not be_valid }		
  end

  # Chekcign that the password is longer then 5 characters
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "return value of authenticate method" do
  	# Save the user to the database
    before { @user.save }
    # Find the correct user given the email. This lets us not have to search
    # for the user more than once
    let(:found_user) { User.find_by(email: @user.email) }

    # Tests to make sure the uesr that is obtains is the same, eq comapres
    # two objects (similar to ==)
    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    # Tests to make sure the correct user is not grabbed since the 
    # password was invalid. specify is same as it and is used when it does 
    # not make sense in terms of grammer
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  # Save a new user and check to make sure that there is a token
  describe "remember token" do
    before { @user.save }
    # its is similar to it but applies ot the attribute of hte subject rather
    # than the subject indicated
    its(:remember_token) { should_not be_blank }
  end 

  # Looks ath te microposts for the test user
  describe "micropost associations" do
    # Save the user before we do anything
    before { @user.save }

    # Create an old micropsot 
    # We use let! because we want @older_micropost to exist immiditly, usually
    # let variabels only exist when referenced
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end

    # Cerating a newer micropost
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    # Check the orde rof the microposts since we have a new nad old one
    it "should have the right microposts in the right order" do
      # This indicated that hte posts hsould be ordered newest first, by
      # default pots will be ordered by id
      # This also checks that user,microposts is working by returning an
      # array of microposts like it should
      # to_a returns the microposts to a propery array we can use
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    # Check that microposts are destroyed when removing a user
    it "should destroy associated microposts" do
      # Saves all the micrposts for the user
      microposts = @user.microposts.to_a

      # Delete/destroy the user
      @user.destroy

      # Check that we still ahve hte microposts we saved
      expect(microposts).not_to be_empty

      # Go through each micropost to make sure all the ones we saved are no
      # longer in the database
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end

    # WE are testing that hte feed on the  home page has the user's microposts
    # and any microposts from anyone they follow
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
  end

  # When the current user is following someone else
  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    # We are checking that the user we are trying to follow has us as a follower
    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    # Tests for unfollowing of a user
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end
end
