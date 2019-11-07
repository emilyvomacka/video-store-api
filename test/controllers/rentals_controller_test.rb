require "test_helper"

describe RentalsController do
  describe "CHECK_OUT" do
    
    describe "successful check_out with valid inputs" do
      it "creates Rental instance with correct attribs" do
      end
      
      it "updates movie's available_inventory correctly" do
      end
      
      it "updates customer's movies_checked_out_count correctly" do
      end
      
      it "returns JSON with success status" do
      end
      
    end
    
    describe "edge" do
      it "if movie's available_inventory = 0, return error msg in JSON and bad_request status" do
      end
      
      
    end
    
  end
  
  describe "CHECK_IN" do
    
    describe "nominal" do
    end
    
    describe "edge" do
    end
    
  end
end
