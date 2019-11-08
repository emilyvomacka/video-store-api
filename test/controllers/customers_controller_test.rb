require "test_helper"

CUSTOMER_KEYS = (%w[id name postal_code phone registered_at movies_checked_out_count]).sort

describe CustomersController do
  
  let(:c2) { customers(:c2) }
  
  describe "INDEX" do
    describe "basic index" do
      it "responds with JSON and success status" do
        get customers_path
        
        check_response(expected_type: Array)
      end
      
      it "if customers exist, responds with an array of customer hashes" do
        get customers_path
        
        body = JSON.parse(response.body)
        
        expect(body.count).must_equal Customer.count
        
        body.each do |customer|
          expect(customer).must_be_instance_of Hash
          expect(customer.keys.sort).must_equal CUSTOMER_KEYS
        end
        
      end
      
      it "if no customers exist, responds with check status and request body" do
        Customer.destroy_all
        
        get customers_path
        
        body = JSON.parse(response.body)
        expect(body.count).must_equal Customer.count
        expect(body).must_equal []
      end
    end
    
    describe "additional query parameters" do
      describe "does query parameter sort work?" do
        it "with each valid input, respond w/ correct JSON and status" do
          # testing all 3 of these choices
          choices = %w[name registered_at postal_code]
          
          choices.each do |choice|
            get customers_path, params: { sort: choice }
            
            check_response(expected_type: Array)
            
            body = JSON.parse(response.body)
            expect(body.count).must_equal Customer.count
            
            body.each do |customer|
              expect(customer).must_be_instance_of Hash
              expect(customer.keys.sort).must_equal CUSTOMER_KEYS
            end
            
            # checking order of name/registerd_at/postal_code
            # why <= and not just <?  bc the timestamps are the same bc computer's fast
            (body.count-1).times do |i|
              assert(body[i][choice] <= body[i+1][choice])
            end
          end
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
          get customers_path, params: { sort: "garbage" }
          
          check_response(expected_type: Hash, expected_status: :bad_request)
          
          body = JSON.parse(response.body)
          expect(body["error"]).must_equal "Can't sort anything with that key"
        end
        
        it "if no customers exist but valid input, responds with check status and request body" do
          Customer.destroy_all
          
          get customers_path, params: { sort: "name"}
          
          body = JSON.parse(response.body)
          expect(body.count).must_equal Customer.count
          expect(body).must_equal []
        end
        
      end
      
      describe "does query parameter combo n&p work?" do
        it "with valid inputs, respond w/ correct JSON and status" do
          params = { n: "1", p: "2" }
          get customers_path, params: params
          
          check_response(expected_type: Array)
          
          body = JSON.parse(response.body)
          expect(body.count).must_equal params[:n].to_i
          
          # hash in body.first should match those of c2
          customer_json = body.first
          expect(customer_json["id"]).must_equal c2.id
          expect(customer_json["name"]).must_equal c2.name
          expect(customer_json["postal_code"]).must_equal c2.postal_code
          expect(customer_json["phone"]).must_equal c2.phone
          expect(customer_json["registered_at"]).must_equal c2.registered_at
          expect(customer_json["movies_checked_out_count"]).must_equal c2.movies_checked_out_count
        end
        
        it "with invalid combo of single input, respond w/ JSON error msg and bad_request status" do 
          bad_params1 = { n: "5" }
          bad_params2 = { p: "10" }
          all_bad_params = [bad_params1, bad_params2]
          
          all_bad_params.each do |bad_param|
            get customers_path, params: bad_param
            
            check_response(expected_type: Hash, expected_status: :bad_request)
            
            body = JSON.parse(response.body)
            expect(body["error"]).must_equal "We require both n and p, not just one of them"
          end
        end
        
        it "with invalid combo of bad n & p values, respond w/ JSON error msg and bad_request status" do
          bad_params1 = { n: "5", p: "garbage" }
          bad_params2 = { n: "garbage", p: "10" }
          bad_params3 = { n: "", p: "garbage" }
          bad_params4 = { n: "0", p: "-3" }
          all_bad_params = [bad_params1, bad_params2, bad_params3, bad_params4]
          
          all_bad_params.each do |bad_param|
            get customers_path, params: bad_param
            
            check_response(expected_type: Hash, expected_status: :bad_request)
            
            body = JSON.parse(response.body)
            expect(body["error"]).must_equal "Invalid n & p combo"
          end
        end
        
        it "if no customers exist but valid input, responds with check status and request body" do
          Customer.destroy_all
          
          get customers_path, params: { n: "10", p: "10"}
          
          body = JSON.parse(response.body)
          expect(body.count).must_equal Customer.count
          expect(body).must_equal []
        end
      end
      
      describe "does query parameter super combo of sort AND n&p work?" do
        it "with valid input, respond w/ correct JSON and status" do
          # TODO, wanted to focus on making other extra functionalities instead
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
          # TODO, wanted to focus on making other extra functionalities instead
        end
        
      end
      
    end
  end
  
end
