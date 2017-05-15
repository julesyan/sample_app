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
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it {should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  # Checking that the object @user is actually valid (and that we have not
  # forgotten anything). Any be_something will also respond with something?
  it { should be_valid } 

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
end
