
require 'test_helper'
require 'minitest/autorun'

class DupTest < ActiveSupport::TestCase
  fixtures :all

  it "has method pbt_dup" do
    skip "Feature is being designed"
    user = users(:bob)
    user.defined?(:pbt_dup).must_be_same_as true
    user.class.defined?(:pbt_dup).must_be_same_as true
  end

  it "has method pbt_deep_dup" do
    skip "Feature is being designed"
    user = users(:bob)
    user.defined?(:pbt_deep_dup).must_be_same_as true
    user.class.defined?(:pbt_deep_dup).must_be_same_as true
  end

end
