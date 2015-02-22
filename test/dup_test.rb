
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
    #skip "Prepping method. It's in the making."
    user1 = users(:steve)
    bob_prof = profiles(:bob_prof)
    contact = user1.contacts.new
    contact.pbt_deep_dup_build(bob_prof)
    cp = contact.profile
    cpa = cp.addresses
    cpaf = cpa.first
    CleanAttrs[cp                               ].must_equal CleanAttrs[bob_prof]
    CleanAttrs[cpaf                             ].must_equal CleanAttrs[bob_prof.addresses.first]
    CleanAttrs[cpaf.squishies.first             ].must_equal CleanAttrs[bob_prof.addresses.first.squishies.first]
    CleanAttrs[cpaf.geo_location                ].must_equal CleanAttrs[bob_prof.addresses.first.geo_location]
    CleanAttrs[cpaf.geo_location.squishies.first].must_equal CleanAttrs[bob_prof.addresses.first.geo_location.squishies.first]
    CleanAttrs[cp.addresses.last                ].must_equal CleanAttrs[bob_prof.addresses.last]
    CleanAttrs[cp.phones.first                  ].must_equal CleanAttrs[bob_prof.phones.first]
    CleanAttrs[cp.phones.first.squishy          ].must_equal CleanAttrs[bob_prof.phones.first.squishy]
    CleanAttrs[cp.phones.last                   ].must_equal CleanAttrs[bob_prof.phones.last]
    CleanAttrs[cp.photo                         ].must_equal CleanAttrs[bob_prof.photo]
  end
end