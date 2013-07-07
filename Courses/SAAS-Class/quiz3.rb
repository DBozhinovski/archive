class Movie < ActiveRecord::Base
  def make_adult
    @rating = 'X'
  end
end

m = Movie.find_by_title("Carrie")
m.make_adult
m.save!

puts Movie.find_by_title("Carrie").rating