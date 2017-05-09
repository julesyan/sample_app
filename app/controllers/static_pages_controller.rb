#Static pages do not use the REST actions (look at the demo_app as an example 
	#for the controllers) because it is static, this is normal
class StaticPagesController < ApplicationController
	#This function, in Ruby will not do anything, but because it inherits, 
		#this function will do stuff because of Rails. Rails will render the 
		#View
  def home
  end

  def help
  end

  def about
  end
end
