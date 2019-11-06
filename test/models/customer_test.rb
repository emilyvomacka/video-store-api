require "test_helper"

describe Customer do
  let (:m1) { movies(:m1) }
  let (:m2) { movies(:m2) }
  let (:c1) { customers(:c1) }
  let (:c2) { customers(:c2) }
  let (:r1) { rentals(:r1) }
  let (:r2) { rentals(:r2) }
  let (:c3) { customers(:c3) }
  
  describe "RELATION" do
    describe "has many rentals" do
      it "can get correct rentals count for valid customer" do
        expect(c1.rentals.count).must_equal 1
      end
      
      it "if no rentals, return 0 rental count" do
        expect(c3.rentals.count).must_equal 0
      end
    end
    
    describe "has many movies" do 
      it "has many movies, thru rentals" do
        expect(c2.movies.count).must_equal 1 
      end
      
      it "responds with an empty array if no movies have been rented" do
        expect(c3.movies.count).must_equal 0 
      end
    end 
  end
  
  describe "VALIDATION" do
    
    ### NONE SO FAR
    it "creates a valid new customer with all required fields filled in" do
      expect{Customer.create!(name: "test", phone: "333")}.must_change "Customer.count", 1

      new_cust = Customer.last
      expect(new_cust.phone).must_equal "333"
      expect(new_cust.name).must_equal "test"
    end 

    it "fails to create a customer without name" do
      expect{Customer.create(name: nil, phone: "333")}.wont_change "Customer.count"
    end 

    it "fails to create a customer without phone number" do
      expect{Customer.create(name: "test", phone: nil)}.wont_change "Customer.count"
    end 

    it "fails to create a customer without unique phone number" do 
      Customer.create!(name: "test", phone: "333")
      expect{Customer.create(name: "hi", phone: "333")}.wont_change "Customer.count"
    end 
  end
  
  describe "CUSTOM METHODS" do
    ### NONE SO FAR
    it "nominal" do
    end
    
    it "edge" do
    end
  end
end
