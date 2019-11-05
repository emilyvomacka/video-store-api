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
    
    describe "has many movies, thru rentals" do
      it "nominal" do
      end
      
      it "edge" do
      end
    end
  end
  
  describe "VALIDATION" do
    ### NONE SO FAR
    it "nominal" do
    end
    
    it "edge" do
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
