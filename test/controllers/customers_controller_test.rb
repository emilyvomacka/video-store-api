require "test_helper"

CUSTOMER_KEYS = (%w[id name postal_code phone registered_at movies_checked_out_count]).sort

describe CustomersController do
  
  describe "INDEX" do
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
  
end
