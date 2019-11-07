require "test_helper"

CUSTOMER_KEYS = (%w[id name postal_code phone registered_at movies_checked_out_count]).sort

describe CustomersController do
  
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
          # I did NOT do input validation, I could've ... but I didn't lol
          # this is expecting the same result as the describe "basic index" block
          get customers_path, params: { sort: "garbage" }
          
          body = JSON.parse(response.body)
          
          expect(body.count).must_equal Customer.count
          
          body.each do |customer|
            expect(customer).must_be_instance_of Hash
            expect(customer.keys.sort).must_equal CUSTOMER_KEYS
          end
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
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
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
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
        end
        
      end
      
      
    end
  end
  
end
