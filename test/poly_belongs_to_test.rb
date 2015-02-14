require 'test_helper'
require 'minitest/autorun'

class PolyBelongsToTest < ActiveSupport::TestCase
  fixtures :all

  it "is a module" do
    PolyBelongsTo.must_be_kind_of Module
  end

  it "reports User as not polymorphic" do
    user = users(:one)
    user.poly?.must_be_same_as false
    User.poly?.must_be_same_as false
  end

  it "reports Tag as not polymorphic" do
    tag = tags(:one)
    tag.poly?.must_be_same_as false
    Tag.poly?.must_be_same_as false
  end

  it "reports Phone as polymorphic" do
    phone = phones(:one)
    phone.poly?.must_be_same_as true
    Phone.poly?.must_be_same_as true
  end

  it "reports User belongs to relation table as nil" do
    user = users(:one)
    user.pbt.must_be_nil
    User.pbt.must_be_nil
  end
  
  it "reports Tag belongs to relation table as :user" do
    tag = tags(:one)
    tag.pbt.must_be_same_as :user
    Tag.pbt.must_be_same_as :user
  end
  
  it "reports Phone belongs to relation table as :phoneable" do
    phone = phones(:one)
    phone.pbt.must_be_same_as :phoneable
    Phone.pbt.must_be_same_as :phoneable
  end
  
  it "reports User params name as :user" do
    user = users(:one)
    user.pbt_params_name.must_be_same_as :user
    User.pbt_params_name.must_be_same_as :user
    User.pbt_params_name(true).must_be_same_as :user
    User.pbt_params_name(false).must_be_same_as :user
  end
  
  it "reports Tag params name as :tag" do
    tag = tags(:one)
    tag.pbt_params_name.must_be_same_as :tag
    Tag.pbt_params_name.must_be_same_as :tag
    Tag.pbt_params_name(true).must_be_same_as :tag
    Tag.pbt_params_name(false).must_be_same_as :tag
  end
  
  it "reports Phone params name as :phones_attributes" do
    phone = phones(:one)
    phone.pbt_params_name.must_be_same_as :phones_attributes
    Phone.pbt_params_name.must_be_same_as :phones_attributes
    Phone.pbt_params_name(true).must_be_same_as :phones_attributes
  end
  
  it "reports Phone params name with false as :phone" do
    phone = phones(:one)
    phone.pbt_params_name(false).must_be_same_as :phone
    Phone.pbt_params_name(false).must_be_same_as :phone
  end
  
  it "reports User belongs to field id symbol as nil" do
    user = users(:one)
    user.pbt_id_sym.must_be_nil
    User.pbt_id_sym.must_be_nil
  end
  
  it "reports Tag belongs to field id symbol as :tag_id" do
    tag = tags(:one)
    tag.pbt_id_sym.must_be_same_as :user_id
    Tag.pbt_id_sym.must_be_same_as :user_id
  end
  
  it "reports Phone belongs to field id symbol as :phoneable_id" do
    phone = phones(:one)
    phone.pbt_id_sym.must_be_same_as :phoneable_id
    Phone.pbt_id_sym.must_be_same_as :phoneable_id
  end
  
  it "reports User belongs to field type symbol as nil" do
    user = users(:one)
    user.pbt_type_sym.must_be_nil
    User.pbt_type_sym.must_be_nil
  end
  
  it "reports Tag belongs to field type symbol as nil" do
    tag = tags(:one)
    tag.pbt_type_sym.must_be_nil
    Tag.pbt_type_sym.must_be_nil
  end
  
  it "reports Phone belongs to field type symbol as :phoneable_type" do
    phone = phones(:one)
    phone.pbt_type_sym.must_be_same_as :phoneable_type
    Phone.pbt_type_sym.must_be_same_as :phoneable_type
  end
  
  it "reports User belongs to relation id as nil" do
    user = users(:one)
    user.pbt_id.must_be_nil
  end
  
  it "reports Tag belongs to relation id as 1" do
    tag = tags(:one)
    tag.pbt_id.must_be_same_as 1
  end
  
  it "reports Phone belongs to relation id as 1" do
    phone = phones(:one)
    phone.pbt_id.must_be_same_as 1
  end

  it "reports User belongs to relation type as nil" do
    user = users(:one)
    user.pbt_type.must_be_nil
  end
  
  it "reports Tag belongs to relation type as nil" do
    tag = tags(:one)
    tag.pbt_type.must_be_nil
  end
  
  it "reports Phone belongs to relation type as 'User'" do
    phone = phones(:one)
    phone.pbt_type.must_equal "User"
  end

  it "User parent request returns nil" do
    user = users(:one)
    user.pbt_parent.must_be_nil
  end
  
  it "Tag parent request returns User instance" do
    user = users(:one)
    tag = user.tags.build
    tag.pbt_parent.id.must_be_same_as user.id
  end
  
  it "Phone parent request returns User instance" do
    user = users(:one)
    phone = user.phones.build
    phone.pbt_parent.id.must_be_same_as user.id
  end

end
