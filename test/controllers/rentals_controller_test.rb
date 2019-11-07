require "test_helper"

describe RentalsController do
  describe "CHECK_OUT" do
    
    let (:m1) { movies(:m1) }
    let (:c3) { customers(:c3) }
    
    describe "successful check_out with valid inputs" do
      
      before do
        # is this better than having a huge IT block?
        @rental_count_before = Rental.count
        @m1_avail_inv_before = m1.available_inventory
        @c3_movie_count_before = c3.movies_checked_out_count
        post check_out_path, params: {movie_id: m1.id, customer_id: c3.id}
        
        @m1_avail_inv_after = (Movie.find_by(id: m1.id)).available_inventory
        @c3_movie_count_after = (Customer.find_by(id: c3.id)).movies_checked_out_count
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
        expect(@m1_avail_inv_after).must_equal @m1_avail_inv_before - 1
      end
      
      it "updates customer's movies_checked_out_count correctly" do
        ### WHY???!!! Postman still passed! I also manually tested in rails console!
        expect(@c3_movie_count_after).must_equal @c3_movie_count_before + 1
      end
      
      it "returns success status & JSON with expected message" do
        check_response(expected_type: Hash, expected_status: :success)
        
        body = JSON.parse(response.body)
        expect(body.keys).must_equal ["msg"]
        expect(body.values).must_equal ["Rental id #{Rental.last.id}: #{m1.title} due on #{Rental.last.due_date}"]
      end
      
    end
    
    describe "edge cases" do
      it "if movie's available_inventory = 0, return error msg in JSON and bad_request status" do
        m1.update!(available_inventory: 0)
        
        expect{post check_out_path, params: {movie_id: m1.id, customer_id: c3.id}}.wont_change "Rental.count"
        check_response(expected_type: Hash, expected_status: :bad_request)
        
        body = JSON.parse(response.body)
        expect(body.keys).must_equal ["errors"]
        expect(body.values).must_equal ["Cannot make a rental because movie #{m1.title.capitalize} ran out of copies"]
      end
      
      it "if rental.save unsuccessful due to nonexistent customer, return error msg in JSON and bad_request status" do
        nil_customer_hash = {movie_id: m1.id, customer_id: nil}
        bad_rental = Rental.create(nil_customer_hash)
        
        post check_out_path, params: nil_customer_hash
        
        check_response(expected_type: Hash, expected_status: :bad_request)
        
        body = JSON.parse(response.body)
        expect(body.keys.sort).must_equal ["error_msgs", "errors"]
        expect(body["errors"]).must_equal "Cannot make a rental"
        expect(body["error_msgs"]).must_equal bad_rental.errors.full_messages
      end
      
      
      it "if rental.save unsuccessful due to nonexistent movie, return error msg in JSON and bad_request status" do
        nil_movie_hash = {movie_id: nil, customer_id: c3.id}
        
        bad_rental = Rental.create(nil_movie_hash)
        
        post check_out_path, params: nil_movie_hash
        
        check_response(expected_type: Hash, expected_status: :bad_request)
        
        body = JSON.parse(response.body)
        expect(body.keys.sort).must_equal ["error_msgs", "errors"]
        expect(body["errors"]).must_equal "Cannot make a rental"
        expect(body["error_msgs"]).must_equal bad_rental.errors.full_messages
      end
    end
    
  end
  
  describe "CHECK_IN" do
    
    describe "successful check-ins with valid inputs" do
      
      it "will not add new rental instances" do
        # TODO
      end
      
      it "will increment movie.available_inventory by 1" do
        # TODO
      end
      
      it "will not decrease customer's movies_checked_out by 1" do
        # TODO
      end
      
      it "returns success status & JSON with expected message" do
        # TODO
      end
      
    end
    
    describe "edge cases" do
      it "if rental doesn't exist, return error msg in JSON and bad_request status" do
        # TODO
        # render json: { errors: "Rental doesn't exist" }, status: :bad_request
        
      end      
      
      it "if movie has already been returned" do
        # TODO
        # render json: { errors: "Rental has already been returned" }, status: :bad_request
        
      end
      
    end
  end
end
