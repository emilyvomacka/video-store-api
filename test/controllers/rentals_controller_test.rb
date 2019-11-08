require "test_helper"
require 'pry'

describe RentalsController do
  describe "CHECK_OUT" do
    
    let (:m1) { movies(:m1) }
    let (:c3) { customers(:c3) }
    
    describe "successful check_out with valid inputs" do
      
      before do
        @rental_count_before = Rental.count
        @m1_avail_inv_before = m1.available_inventory
        @c3_movie_count_before = c3.movies_checked_out_count
        post check_out_path, params: {movie_id: m1.id, customer_id: c3.id}
        c3.reload
        @c3_movie_count_after = c3.movies_checked_out_count
      end
      
      it "creates Rental instance with correct attribs" do
        expect(Rental.count).must_equal @rental_count_before+1
        
        rental = Rental.last
        expect(rental.movie).must_equal m1
        expect(rental.customer).must_equal c3
        expect(rental.checkout_date).must_equal Date.today
        expect(rental.due_date).must_equal (Date.today + 7.days)
        expect(rental.returned).must_equal false
      end
      
      it "updates movie's available_inventory correctly" do
        @m1_avail_inv_after = (Movie.find_by(id: m1.id)).available_inventory
        expect(@m1_avail_inv_after).must_equal @m1_avail_inv_before - 1
      end
      
      it "updates customer's movies_checked_out_count correctly" do
        
        expect(@c3_movie_count_after).must_equal @c3_movie_count_before + 1
      end
      
      it "returns success status & JSON with expected message" do
        body = check_response(expected_type: Hash, expected_status: :success)
        
        expect(body.keys).must_equal ["msg"]
        expect(body.values).must_equal ["Rental id #{Rental.last.id}: #{m1.title} due on #{Rental.last.due_date}"]
      end
      
    end
    
    describe "edge cases" do
      it "if movie's available_inventory = 0, return error msg in JSON and bad_request status" do
        m1.update!(available_inventory: 0)
        
        expect{post check_out_path, params: {movie_id: m1.id, customer_id: c3.id}}.wont_change "Rental.count"
        body = check_response(expected_type: Hash, expected_status: :bad_request)
        
        expect(body.keys).must_equal ["error"]
        expect(body.values).must_equal ["Cannot make a rental because movie #{m1.title.capitalize} ran out of copies"]
      end
      
      it "if rental.save unsuccessful due to nonexistent customer, return error msg in JSON and bad_request status" do
        nil_customer_hash = {movie_id: m1.id, customer_id: nil}
        bad_rental = Rental.create(nil_customer_hash)
        
        post check_out_path, params: nil_customer_hash
        
        body = check_response(expected_type: Hash, expected_status: :bad_request)
        
        expect(body.keys.sort).must_equal ["error", "error_msgs"]
        expect(body["error"]).must_equal "Cannot make a rental"
        expect(body["error_msgs"]).must_equal bad_rental.errors.full_messages
      end
      
      
      it "if rental.save unsuccessful due to nonexistent movie, return error msg in JSON and bad_request status" do
        nil_movie_hash = {movie_id: -2, customer_id: c3.id}
        
        bad_rental = Rental.create(nil_movie_hash)
        
        post check_out_path, params: nil_movie_hash
        
        check_response(expected_type: Hash, expected_status: :bad_request)
        
        body = JSON.parse(response.body)
        expect(body.keys.sort).must_equal ["error", "error_msgs"]
        expect(body["error"]).must_equal "Cannot make a rental"
        expect(body["error_msgs"]).must_equal bad_rental.errors.full_messages
      end
    end
    
  end
  
  describe "CHECK_IN" do
    let (:c1) { customers(:c1) }
    let (:c2) { customers(:c2) }
    let (:m1) { movies(:m1) }
    let (:m2) { movies(:m2) }
    let (:r2) { rentals(:r2) }
    let (:check_in_params) { {movie_id: m1.id, customer_id: c2.id} }
    
    before do
      @m1_starting_avail_inventory = m1.available_inventory
      @c2_starting_movies_co_count = c2.movies_checked_out_count
    end 
    
    it "successfully checks in a checked-out movie" do       
      expect{ post check_in_path, params: check_in_params }.wont_change Rental.count
      c2.reload
      expect(c2.movies_checked_out_count).must_equal @c2_starting_movies_co_count - 1
      m1.reload
      expect(m1.available_inventory).must_equal @m1_starting_avail_inventory + 1
      expect(r2.returned).must_equal true 
    end 
    
    it "returns success status & JSON with expected message" do
      post check_in_path, params: check_in_params 
      body = check_response(expected_type: Hash)
      expect(body.values).must_equal ["Rental id #{r2.id}: #{r2.movie.title} has been returned."]
    end
    
    it "if rental has already been returned, return error msg in JSON with :bad_request status" do
      bad_params = { movie_id: m1.id, customer_id: c1.id}
      
      post check_in_path, params: bad_params
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_equal ["error"]
      expect(body.values).must_equal ["Rental has already been returned"]
    end      
    
    it "if rental doesn't exist, return error msg in JSON with :bad_request status" do
      bad_params = { movie_id: m2.id, customer_id: c2.id }
      
      post check_in_path, params: bad_params
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_equal ["error"]
      expect(body.values).must_equal ["Rental doesn't exist"]
    end
  end
end

