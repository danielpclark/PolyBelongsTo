
require 'test_helper'
require 'minitest/autorun'

class DupTest < ActiveSupport::TestCase
  fixtures :all

  setup do
    ActiveRecord::Base.send(:include, PolyBelongsTo::Dup)
  end

  it "has method pbt_dup" do
    User.instance_methods.include?(:pbt_dup).must_be_same_as true
    User.methods.include?(:pbt_dup).must_be_same_as true
  end

  it "has method pbt_deep_dup" do
    User.instance_methods.include?(:pbt_deep_dup).must_be_same_as true
    User.methods.include?(:pbt_deep_dup).must_be_same_as true
  end

end
