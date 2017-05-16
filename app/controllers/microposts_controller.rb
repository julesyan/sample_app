class MicropostsController < ApplicationController
  # Before we do anything, we check if a signed in user for the create and
  # destroy functions (this is a filter)
  before_action :signed_in_user, only: [:create, :destroy]

  # Filter so that only the correct user can delete a post
  before_action :correct_user, only: :destroy

  # This is to create a micropost
  def create
  	# Create a new micropsot object
    @micropost = current_user.microposts.build(micropost_params)
    # Save the micropsot to the database
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # When there is an error in submitting a micropost, we still need this
      # variable
      @feed_items = []
      render 'static_pages/home'
    end
  end

  # This is to delete a micropost
  def destroy
    @micropost.destroy
    redirect_to root_url
  end

  private

  	# This is to fill in the parameters of the micropost which is the contents
    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # Filter to know if correct user
    # We go through the association to get hte data we need so that we can 
    # insure the data is only for the user
    def correct_user
      # We use find_by instead of find because find will raise and error if
      # it doesn't exist and find_by iwll return nil
      @micropost = current_user.microposts.find_by(id: params[:id])

      # if the post is nil then go to hoem page
      redirect_to root_url if @micropost.nil?
    end
end