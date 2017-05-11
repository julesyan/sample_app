# Include the application helper functions that we created for testing
include ApplicationHelper


# Function that does the same thing as the full_title function from before
def full_title(page_title)
  base_title = "Ruby on Rails Tutorial Sample App"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end