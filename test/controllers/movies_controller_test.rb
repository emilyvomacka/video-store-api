require "test_helper"

MOVIE_KEYS = (%w[id name postal_code phone registered_at movies_checked_out_count]).sort

describe MoviesController do
  describe "INDEX" do
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
          expect(movie.keys.sort).must_equal CUSTOMER_KEYS
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
    it "basic test w/ no parameters, if applicable" do
    end

    it "nominal case: check status and request body" do
    end

    it "edge case: check status and request body" do
    end
  end

  describe "CREATE" do
    it "basic test w/ no parameters, if applicable" do
    end

    it "nominal case: check status and request body" do
    end

    it "edge case: check status and request body" do
    end
  end
end
