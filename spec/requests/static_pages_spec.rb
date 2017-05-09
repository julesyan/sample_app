# Removed all generated code from this file, below is testing specific Ruby code (RSpec)
require 'spec_helper'

describe "Static pages" do
  let (:title) {"Ruby on Rails Tutorial Sample App | "}


  # Below is decribing the home page and what it should contain
  describe "Home page" do
    # The 'it' line describes to readers what the page should have, it is irrelevent
    # to the actual code 
    it "should have the content 'Sample App'" do
      #Here we go to the approprite page and then check the contents of it
      visit '/static_pages/home'
      expect(page).to have_content('Sample App') 
    end

    #Checks that the home page has the approprite title, checks the contents inside 
    #of  the <title> tag. have_title checks substring so the title does no have to 
    #be an exact match
    it "should have the base title" do
      visit '/static_pages/home'
      expect(page).to have_title("Ruby on Rails Tutorial Sample App")
    end

    #Making sure the title is not a custom one, we are using substrings
    #for this test case 
    it "should not have a custom title" do
      visit '/static_pages/home'
      expect(page).not_to have_title('| Home')
    end
  end

  #Below is describign the Help page
  describe "Help page" do 
    # When given an error, will use this line to describe what hte pag should contain
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end

    it "should have the title 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_title("#{title}Help")
    end
  end 

  #Below is describing the About page
  describe "About page" do 
    it "should have the content 'About Us'" do 
      visit '/static_pages/about'
      expect(page).to have_content('About Us')
    end

    it "should have the title 'About'" do
      visit '/static_pages/about'
      expect(page).to have_title("#{title}About")
    end
  end 

  describe 'Contact page' do
    it "should have the content 'Contact" do
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the title 'Contact'" do
      visit '/static_pages/contact'
      expect(page).to have_title("#{title}Contact")
    end
  end
end
