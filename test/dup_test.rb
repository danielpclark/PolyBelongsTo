
require 'test_helper'
require 'minitest/autorun'

class DupTest < ActiveSupport::TestCase
  fixtures :all

  it "has method pbt_dup_build" do
    User.instance_methods.include?(:pbt_dup_build).must_be_same_as true
    User.methods.include?(:pbt_dup_build).must_be_same_as true
  end

  it "has method pbt_deep_dup_build" do
    User.instance_methods.include?(:pbt_deep_dup_build).must_be_same_as true
    User.methods.include?(:pbt_deep_dup_build).must_be_same_as true
  end

  it "builds copy from dup'd attributes" do
    user = users(:bob)
    susan_prof = profiles(:susan_prof)
    contact = user.contacts.new
    contact.pbt_dup_build( susan_prof )
    CleanAttrs[contact.profile].must_equal CleanAttrs[susan_prof]
  end
  
  it "builds deep copy of dup'd attributes" do
    skip "Prepping method. It's in the making."
    #user1 = users(:bob)
    #user2 = users(:steve)
  end
end
