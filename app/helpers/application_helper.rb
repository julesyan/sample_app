module ApplicationHelper
	# This is where all the helper functions go for the application 
	def full_title(page_title)
		base_title = "Ruby on Rails Tutorial Sample App"
		# If we do not have a page_title then we stick the base one in
		if page_title.empty?
			base_title
		else
			# Sets the full title
			"#{base_title} | #{page_title}"
		end
	end
end
