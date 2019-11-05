require "test_helper"

describe Customer do
  it "does a thing" do
    m1 = movies(:m1)
    expect(Movie.count).must_equal 1
    p Movie.first
  end
end
