require "test_helper"

describe Customer do
  let (:m1) { movies(:m1) }
  let (:c1) { customers(:c1) }
  let (:r1) { rentals(:r1) }
  
  describe "RELATION" do
    describe "has many rentals" do
      it "nominal" do
      end
      
      it "edge" do
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
