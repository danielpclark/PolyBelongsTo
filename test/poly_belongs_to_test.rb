require 'test_helper'
require 'minitest/autorun'

class PolyBelongsToTest < ActiveSupport::TestCase
  fixtures :all

  it "is a module" do
    PolyBelongsTo::Core.must_be_kind_of Module
  end

  it "User as not polymorphic" do
    user = users(:bob)
    user.poly?.must_be_same_as false
    User.poly?.must_be_same_as false
  end

  it "Tag as not polymorphic" do
    tag = tags(:bob_tag)
    tag.poly?.must_be_same_as false
    Tag.poly?.must_be_same_as false
  end

  it "Phone as polymorphic" do
    phone = phones(:bob_phone)
    phone.poly?.must_be_same_as true
    Phone.poly?.must_be_same_as true
  end

  it "User belongs to table as nil" do
    user = users(:bob)
    user.pbt.must_be_nil
    User.pbt.must_be_nil
  end
  
  it "Tag belongs to table as :user" do
    tag = tags(:bob_tag)
    tag.pbt.must_be_same_as :user
    Tag.pbt.must_be_same_as :user
  end
  
  it "Phone belongs to table as :phoneable" do
    phone = phones(:bob_phone)
    phone.pbt.must_be_same_as :phoneable
    Phone.pbt.must_be_same_as :phoneable
  end
  
  it "User params name as :user" do
    user = users(:bob)
    user.pbt_params_name.must_be_same_as :user
    User.pbt_params_name.must_be_same_as :user
    User.pbt_params_name(true).must_be_same_as :user
    User.pbt_params_name(false).must_be_same_as :user
  end
  
  it "Tag params name as :tag" do
    tag = tags(:bob_tag)
    tag.pbt_params_name.must_be_same_as :tag
    Tag.pbt_params_name.must_be_same_as :tag
    Tag.pbt_params_name(true).must_be_same_as :tag
    Tag.pbt_params_name(false).must_be_same_as :tag
  end
  
  it "Phone params name as :phones_attributes" do
    phone = phones(:bob_phone)
    phone.pbt_params_name.must_be_same_as :phones_attributes
    Phone.pbt_params_name.must_be_same_as :phones_attributes
    Phone.pbt_params_name(true).must_be_same_as :phones_attributes
  end
  
  it "Phone params name with false as :phone" do
    phone = phones(:bob_phone)
    phone.pbt_params_name(false).must_be_same_as :phone
    Phone.pbt_params_name(false).must_be_same_as :phone
  end
  
  it "User belongs to field id symbol as nil" do
    user = users(:bob)
    user.pbt_id_sym.must_be_nil
    User.pbt_id_sym.must_be_nil
  end
  
  it "Tag belongs to field id symbol as :tag_id" do
    tag = tags(:bob_tag)
    tag.pbt_id_sym.must_be_same_as :user_id
    Tag.pbt_id_sym.must_be_same_as :user_id
  end
  
  it "Phone belongs to field id symbol as :phoneable_id" do
    phone = phones(:bob_phone)
    phone.pbt_id_sym.must_be_same_as :phoneable_id
    Phone.pbt_id_sym.must_be_same_as :phoneable_id
  end
  
  it "User belongs to field type symbol as nil" do
    user = users(:bob)
    user.pbt_type_sym.must_be_nil
    User.pbt_type_sym.must_be_nil
  end
  
  it "Tag belongs to field type symbol as nil" do
    tag = tags(:bob_tag)
    tag.pbt_type_sym.must_be_nil
    Tag.pbt_type_sym.must_be_nil
  end
  
  it "Phone belongs to field type symbol as :phoneable_type" do
    phone = phones(:bob_phone)
    phone.pbt_type_sym.must_be_same_as :phoneable_type
    Phone.pbt_type_sym.must_be_same_as :phoneable_type
  end
  
  it "User belongs to id as nil" do
    user = users(:bob)
    user.pbt_id.must_be_nil
  end
  
  it "Tag belongs to id as user's id" do
    tag = tags(:bob_tag)
    tag.pbt_id.must_be_same_as ActiveRecord::FixtureSet.identify(:bob)
  end
  
  it "Phone belongs to id as user's profile id" do
    phone = phones(:bob_phone)
    phone.pbt_id.must_be_same_as ActiveRecord::FixtureSet.identify(:bob_prof)
  end

  it "User belongs to type as nil" do
    user = users(:bob)
    user.pbt_type.must_be_nil
  end
  
  it "Tag belongs to type as nil" do
    tag = tags(:bob_tag)
    tag.pbt_type.must_be_nil
  end
  
  it "Phone belongs to type as 'Profile'" do
    phone = phones(:bob_phone)
    phone.pbt_type.must_equal "Profile"
  end

  it "User parent returns nil" do
    user = users(:bob)
    user.pbt_parent.must_be_nil
  end
  
  it "Tag parent returns user instance" do
    user = users(:bob)
    tag = user.tags.build
    tag.pbt_parent.id.must_be_same_as user.id
  end
  
  it "Phone parent returns profile" do
    user = users(:bob)
    profile = user.profiles.build
    phone = profile.phones.build
    profile.save
    phone.pbt_parent.id.must_be_same_as profile.id
  end

  it "Profile parent returns user" do
    user = users(:bob)
    profile = user.profiles.build
    profile.save
    profile.pbt_parent.id.must_be_same_as user.id
  end

end
