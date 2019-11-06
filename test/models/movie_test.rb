require "test_helper"

describe Movie do
  let (:m1) { movies(:m1) }
  let (:m2) { movies(:m2) }
  let (:c1) { customers(:c1) }
  let (:c2) { customers(:c2) }
  let (:r1) { rentals(:r1) }
  let (:r2) { rentals(:r2) }
  let (:actual_m1_rentals) { rentals.select { |r| r.movie == m1 } }
  let (:actual_m2_rentals) { rentals.select { |r| r.movie == m2 } }
  
  describe "RELATION" do
    describe "has many rentals" do
      it "can get correct rentals count for valid movie" do
        expect(m1.rentals.count).must_equal actual_m1_rentals.count
      end
      
      it "if no rentals, return 0 rental count" do
        expect(m2.rentals.count).must_equal actual_m2_rentals.count
      end
    end
    
    describe "has many customers, thru rentals" do
      it "can get correct customers count for valid movie" do
        expect(m1.customers.count).must_equal actual_m1_rentals.count
      end
      
      it "if no rentals, return 0 customer count" do
        expect(m2.customers.count).must_equal actual_m2_rentals.count
      end
    end
  end
  
  describe "VALIDATION" do
    describe "nominal" do
      it "creates a movie when all required fields are present and correct" do
        expect{Movie.create(title: "test", inventory: 3)}.must_change "Movie.count", 1
      end
      
      describe "edge" do
        it "won't create a movie without a title" do 
          expect{Movie.create(title: nil, inventory: 3)}.wont_change "Movie.count"
        end 
        
        it "won't create a movie without an inventory" do 
          expect{Movie.create(title: "test", inventory: nil)}.wont_change "Movie.count"
        end 
        
        it "won't create movie with negative inventory" do 
          expect{Movie.create(title: "test", inventory: -25)}.wont_change "Movie.count"
        end 
      end
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