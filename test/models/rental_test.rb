require "test_helper"

describe Rental do
  let (:m1) { movies(:m1) }
  let (:m2) { movies(:m2) }
  let (:c1) { customers(:c1) }
  let (:c2) { customers(:c2) }
  let (:r1) { rentals(:r1) }
  let (:r2) { rentals(:r2) }
  
  describe "RELATION" do
    it "valid Rental instance belongs to 1 movie" do
      expect(r1.movie).must_equal m1
      
      # no such thing as r1.movieS
      expect{r1.movies}.must_raise NoMethodError
    end
    
    it "valid Rental instance belongs to 1 customer" do
      expect(r1.customer).must_equal c1
      
      # no such thing as r1.customerS
      expect{r1.customers}.must_raise NoMethodError
    end
    
    it "edge cases?" do
      # if invalid customer or movie given, Rental instance won't even add to database successfully
      # therefore no edge case to test re: movie or customer associations
      assert(true)
    end
  end
  
  describe "VALIDATION" do
    it "can add new Rental instance, if given valid customer & movie instances" do
      expect{Rental.create(customer: Customer.first, movie: Movie.last)}.must_change "Rental.count", 1
    end
    
    it "won't add new Rental instance if given bad customer instance" do
      before_count = Rental.count
      expect{Rental.create(customer: "garbage", movie: Movie.last)}.must_raise ActiveRecord::AssociationTypeMismatch
      expect(Rental.count).must_equal before_count
    end
    
    it "won't add new Rental instance if given bad movie instance" do
      before_count = Rental.count
      expect{Rental.create(customer: Customer.first, movie: "garbage")}.must_raise ActiveRecord::AssociationTypeMismatch
      expect(Rental.count).must_equal before_count
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
