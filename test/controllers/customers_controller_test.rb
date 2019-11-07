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
        it "with valid input, respond w/ correct JSON and status" do
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
        end

      end
      
      describe "does query parameter combo n&p work?" do
        it "with valid input, respond w/ correct JSON and status" do
        end
        
        it "with invalid inputs, respond w/ default JSON of all customers and success status" do 
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
