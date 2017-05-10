# Removed all generated code from this file, below is testing specific Ruby code (RSpec)
require 'spec_helper'

describe "Static pages" do
  let (:title) {"Ruby on Rails Tutorial Sample App | "}
    subject { page }


  # Below is decribing the home page and what it should contain
  describe "Home page" do
    # visit the page before hand
    before { visit root_path }

    # The 'it' line describes to readers what the page should have, it is irrelevent
    # to the actual code 
    #it "should have the content 'Sample App'" do
      #Here we go to the approprite page and then check the contents of it
      #visit root_path
      #expect(page).to have_content('Sample App') 
    #end
    it { should have_content('Sample App') }

    #Checks that the home page has the approprite title, checks the contents inside 
    #of  the <title> tag. have_title checks substring so the title does no have to 
    #be an exact match
    #it "should have the base title" do
      #visit root_path
      #expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    #end
    it { should have_title(full_title('')) }

    #Making sure the title is not a custom one, we are using substrings
    #for this test case 
    #it "should not have a custom title" do
      #visit root_path
      #expect(page).not_to have_title('| Home')
    #end
    it { should_not have_title('| Home') }
  end

  #Below is describign the Help page
  describe "Help page" do 
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end 

  #Below is describing the About page
  describe "About page" do 
    
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About')) }
  end 

  describe 'Contact page' do
    
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end
