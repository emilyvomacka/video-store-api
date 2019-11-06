JSON.parse(File.read('db/seeds/customers.json')).each do |customer|
  Customer.create!(customer)
end

JSON.parse(File.read('db/seeds/movies.json')).each do |movie|
  new_movie = Movie.new(movie)
  new_movie.available_inventory = new_movie.inventory
  new_movie.save!
end
