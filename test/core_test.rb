require 'test_helper'
require 'minitest/autorun'

class CoreTest < ActiveSupport::TestCase
  fixtures :all

  describe PolyBelongsTo::Core do

    it "is a module" do
      PolyBelongsTo::Core.must_be_kind_of Module
    end

    it "#poly? User as not polymorphic" do
      user = users(:bob)
      user.wont_be :poly?
      User.wont_be :poly?
    end

    it "#poly? Tag as not polymorphic" do
      tag = tags(:bob_tag)
      tag.wont_be :poly?
      Tag.wont_be :poly?
    end

    it "#poly? Phone as polymorphic" do
      phone = phones(:bob_phone)
      phone.must_be :poly?
      Phone.must_be :poly?
    end

    it "#pbt User belongs to table as nil" do
      user = users(:bob)
      user.pbt.must_be_nil
      User.pbt.must_be_nil
    end
    
    it "#pbt Tag belongs to table as :user" do
      tag = tags(:bob_tag)
      tag.pbt.must_be_same_as :user
      Tag.pbt.must_be_same_as :user
    end 
    
    it "#pbt Phone belongs to table as :phoneable" do
      phone = phones(:bob_phone)
      phone.pbt.must_be_same_as :phoneable
      Phone.pbt.must_be_same_as :phoneable
    end
 
    it "#pbts multiple parents" do
      tire = tires(:low_profile1)
      parents = tire.class.pbts
      parents.must_be_kind_of Array
      parents.must_include :user
      parents.must_include :car
      parents = tire.pbts
      parents.must_be_kind_of Array
      parents.must_include :user
      parents.must_include :car
    end
   
    it "#pbt_params_name User params name as :user" do
      user = users(:bob)
      user.pbt_params_name.must_be_same_as :user
      User.pbt_params_name.must_be_same_as :user
      User.pbt_params_name(true).must_be_same_as :user
      User.pbt_params_name(false).must_be_same_as :user
    end
    
    it "#pbt_params_name Tag params name as :tag" do
      tag = tags(:bob_tag)
      tag.pbt_params_name.must_be_same_as :tag
      Tag.pbt_params_name.must_be_same_as :tag
      Tag.pbt_params_name(true).must_be_same_as :tag
      Tag.pbt_params_name(false).must_be_same_as :tag
    end
    
    it "#pbt_params_name Phone params name as :phones_attributes" do
      phone = phones(:bob_phone)
      phone.pbt_params_name.must_be_same_as :phones_attributes
      Phone.pbt_params_name.must_be_same_as :phones_attributes
      Phone.pbt_params_name(true).must_be_same_as :phones_attributes
    end
    
    it "#pbt_params_name Phone params name with false as :phone" do
      phone = phones(:bob_phone)
      phone.pbt_params_name(false).must_be_same_as :phone
      Phone.pbt_params_name(false).must_be_same_as :phone
    end
    
    it "#pbt_id_sym User belongs to field id symbol as nil" do
      user = users(:bob)
      user.pbt_id_sym.must_be_nil
      User.pbt_id_sym.must_be_nil
    end
    
    it "#pbt_id_sym Tag belongs to field id symbol as :tag_id" do
      tag = tags(:bob_tag)
      tag.pbt_id_sym.must_be_same_as :user_id
      Tag.pbt_id_sym.must_be_same_as :user_id
    end
    
    it "#pbt_id_sym Phone belongs to field id symbol as :phoneable_id" do
      phone = phones(:bob_phone)
      phone.pbt_id_sym.must_be_same_as :phoneable_id
      Phone.pbt_id_sym.must_be_same_as :phoneable_id
    end
    
    it "#pbt_type_sym User belongs to field type symbol as nil" do
      user = users(:bob)
      user.pbt_type_sym.must_be_nil
      User.pbt_type_sym.must_be_nil
    end
    
    it "#pbt_type_sym Tag belongs to field type symbol as nil" do
      tag = tags(:bob_tag)
      tag.pbt_type_sym.must_be_nil
      Tag.pbt_type_sym.must_be_nil
    end
    
    it "#pbt_type_sym Phone belongs to field type symbol as :phoneable_type" do
      phone = phones(:bob_phone)
      phone.pbt_type_sym.must_be_same_as :phoneable_type
      Phone.pbt_type_sym.must_be_same_as :phoneable_type
    end
    
    it "#pbt_id User belongs to id as nil" do
      user = users(:bob)
      user.pbt_id.must_be_nil
    end
    
    it "#pbt_id Tag belongs to id as user's id" do
      tag = tags(:bob_tag)
      tag.pbt_id.must_be_same_as ActiveRecord::FixtureSet.identify(:bob)
    end
    
    it "#pbt_id Phone belongs to id as user's profile id" do
      phone = phones(:bob_phone)
      phone.pbt_id.must_be_same_as ActiveRecord::FixtureSet.identify(:bob_prof)
    end

    it "#pbt_type User belongs to type as nil" do
      user = users(:bob)
      user.pbt_type.must_be_nil
    end
    
    it "#pbt_type Tag belongs to type as nil" do
      tag = tags(:bob_tag)
      tag.pbt_type.must_be_nil
    end
    
    it "#pbt_type Phone belongs to type as 'Profile'" do
      phone = phones(:bob_phone)
      phone.pbt_type.must_equal "Profile"
    end

    it "#pbt_parent User parent returns nil" do
      user = users(:bob)
      user.pbt_parent.must_be_nil
    end
    
    it "#pbt_parent Tag parent returns user instance" do
      user = users(:bob)
      tag = user.tags.build
      tag.pbt_parent.id.must_be_same_as user.id
    end
    
    it "#pbt_parent Phone parent returns profile" do
      user = users(:bob)
      profile = user.profiles.build
      phone = profile.phones.build
      profile.save
      phone.pbt_parent.id.must_be_same_as profile.id
    end

    it "#pbt_parent Profile parent returns user" do
      user = users(:bob)
      profile = user.profiles.build
      profile.save
      profile.pbt_parent.id.must_be_same_as user.id
    end

    it "#pbt_parents can show multiple parents" do
      user = User.new(id: 1)
      user.cars.build
      user.cars.first.tires.build(user_id: user.id)
      user.save
      parents = user.cars.first.tires.first.pbt_parents
      parents.must_be_kind_of Array
      parents.must_include user
      parents.must_include user.cars.first
      user.destroy
    end

    it "#pbt_parents one parent for polymorphic" do
      bob_address = addresses(:bob_address)
      parents = bob_address.pbt_parents
      parents.must_be_kind_of Array
      parents.size.must_equal 1
      parents.first.must_equal profiles(:bob_prof)
    end
  end

end
