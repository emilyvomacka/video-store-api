require "test_helper"

CUSTOMER_FIELDS = %w(id name phone postal_code registered_at movies_checked_out_count).sort

describe CustomersController do
  
  describe "INDEX" do
    it "responds with JSON, success, and an array of customer hashes" do
      get customers_path
      body = check_response(expected_type: Array)

      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal CUSTOMER_FIELDS
      end 
    end

    it "responds with an empty array when there are no customers" do
      Customer.destroy_all
      get customers_path
      body = check_response(expected_type: Array)
      expect(body).must_be_empty
    end
    
    it "displays list of customers" do
      
    end
    
    it "edge case: check status and request body" do
    end
  end
  
end
