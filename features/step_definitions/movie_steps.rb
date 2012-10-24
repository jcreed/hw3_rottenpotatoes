# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
     Movie.create!(:title => movie[:title].strip, :rating => movie[:rating].strip, :release_date => movie[:release_date].strip)
  end
  
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  e1found = false
  myexp = "//table[@id='movies']/tbody/tr/td"
  title = page.all(:xpath, myexp).map {|t| t.text}
  assert title.index(e1) < title.index(e2)
#  page.all(:xpath, myexp).each do |e|
#    assert e.text == e2 if e1found 
#    e1found = true if e.text == e1 
#  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: "([^\"]*)"/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(",").each do |r|
    if uncheck == "un"
       step %Q{I uncheck "ratings_#{r}"}
    else
       step %Q{I check "ratings_#{r}"}
    end
  end
end

Then /I should see movies rated "(.*)"/ do |rating|
  myexp = "//table[@id='movies']/tbody/tr/td[2]"
  ratings = page.all(:xpath, myexp).map {|t| t.text}
  assert ratings.include?(rating)
end

Then /I should not see movies rated "(.*)"/ do |rating|
  myexp = "//table[@id='movies']/tbody/tr/td[2]"
  ratings = page.all(:xpath, myexp).map {|t| t.text}
  assert !ratings.include?(rating)
end

Then /I should see all of the movies/ do
  myexp = "//table[@id='movies']/tbody/tr/td[1]"
  movies = page.all(:xpath, myexp).map {|t| t.text}
  assert Movie.all.count == movies.size
end

Then /I should see no movies/ do
  myexp = "//table[@id='movies']/tbody/tr/td[1]"
  movies = page.all(:xpath, myexp).map {|t| t.text}
  assert movies.size == 0
end

