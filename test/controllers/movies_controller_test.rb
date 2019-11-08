require "test_helper"

MOVIE_SHOW_KEYS = (%w[id title overview release_date inventory available_inventory]).sort
MOVIE_INDEX_KEYS = (%w[id title release_date]).sort

describe MoviesController do
  describe "INDEX" do
    it "responds with JSON and success status" do
      get movies_path
      check_response(expected_type: Array)
    end
    
    it "if movies exist, responds with an array of movie hashes" do
      get movies_path
      
      body = JSON.parse(response.body)
      
      expect(body.count).must_equal Movie.count
      
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal MOVIE_INDEX_KEYS
      end
      
    end
    
    it "if no movies exist, responds with check status and request body" do
      Movie.destroy_all
      
      get movies_path
      
      body = JSON.parse(response.body)
      expect(body.count).must_equal Movie.count
      expect(body).must_equal []
    end
  end
  
  describe "SHOW" do
    
    let (:m1) {movies(:m1) }
    
    it "responds with JSON, success, and a movie hash" do
      get movie_path(m1)
      body = check_response(expected_type: Hash)
      expect(body.keys.sort).must_equal MOVIE_SHOW_KEYS
    end
    
    it "will respond ok with an error JSON when movie not found" do
      Movie.destroy_all
      get movie_path(-1)
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_equal ["error"]
      expect(body.values).must_equal ["Movie not found"]
    end
  end
  
  describe "CREATE" do
    
    it "creates a movie with correct params" do
      prev_movie_count = Movie.count
      movie_params = { title: "test movie", inventory: 10, overview: "fascinating", release_date: "2019-10-01" } 
      post movies_path, params: movie_params
      must_respond_with :success

      expect(Movie.count).must_equal prev_movie_count + 1
      
      new_movie = Movie.last
      expect(new_movie.title).must_equal "test movie"
      expect(new_movie.inventory).must_equal 10
      expect(new_movie.overview).must_equal "fascinating"
      expect(new_movie.release_date.to_s).must_equal "2019-10-01"
      expect(new_movie.available_inventory).must_equal 10
    end 
    
    it "returns bad_request when movie cannot be created" do
      bad_params = { movie: { title: "bad movie", inventory: -24 } } 
      expect{post movies_path, params: bad_params}.wont_change 'Movie.count'
      must_respond_with :bad_request
    end 
  end
end
