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

    it "#has_one_of" do
      Profile.has_one_of.must_equal [:photo]
    end

    it "#has_many_of" do
      Profile.has_many_of.must_equal [:phones, :addresses]
      HmtAssembly.has_many_of.must_equal [:manifests, :hmt_parts]
      HmtPart.has_many_of.must_equal [:manifests, :hmt_assemblies]
    end

    it "#habtm_of" do
      Assembly.habtm_of.must_equal [:parts]
      Part.habtm_of.must_equal [:assemblies]
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

    it "#pbt_parent returns nil if no ID is set for parent relationship" do
      alpha = Alpha.new;         alpha.save
      beta  = alpha.betas.build; beta.save
      alpha.pbt_parent.must_be_nil
      beta.pbt_parent.wont_be_nil
      beta.pbt_parent.must_equal alpha
      squishy = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address")
      squishy.pbt_parent.must_be_nil
    end

    it "#pbt_top_parent climbs up belongs_to hierarchy to the top; polymorphic relationships first" do
      alpha = Alpha.new;         alpha.save
      beta  = alpha.betas.build; beta.save
      capa  = beta.capas.build;  capa.save
      delta = capa.deltas.build; delta.save
      delta.pbt_top_parent.must_equal alpha
    end

    it "#pbt_top_parent with circular relation goes till the repeat" do
      alpha = Alpha.new;         alpha.save
      beta  = alpha.betas.build; beta.save
      capa  = beta.capas.build;  capa.save
      delta = capa.deltas.build; delta.save
      alpha.update(delta_id: delta.id)
      delta.pbt_top_parent.must_equal alpha
      alpha.pbt_top_parent.must_equal beta
      beta. pbt_top_parent.must_equal capa
      capa. pbt_top_parent.must_equal delta
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

    it "#pbt_orphans returns all parentless records for current Object" do
      obj = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Phone")
      Squishy.pbt_orphans.to_a.must_equal [obj]
      obj2 = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address")
      Squishy.pbt_orphans.to_a.sort.must_equal [obj, obj2].sort
      obj3 = Beta.create(Beta.pbt_id_sym => 12_345)
      Beta.pbt_orphans.to_a.must_equal [obj3]
    end

    it "#pbt_orphans returns nil for non parent type records" do
      User.create()
      User.pbt_orphans.must_be_nil
    end

    it "#pbt_orphans ignores mislabled record types" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Object")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Class")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Squishable")
      Squishy.pbt_orphans.must_be :empty?
    end

    it "#pbt_mistypes returns strings of mislabled polymorphic record types" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Object")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Class")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Squishable")
      Squishy.pbt_mistypes.to_a.sort.must_equal ["Object", "Class", "Squishable"].sort
    end

    it "#pbt_mistyped returns mislabled polymorphic record types" do
      obj = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Object")
      obj2 = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Class")
      obj3 = Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Squishable")
      Squishy.pbt_mistyped.to_a.sort.must_equal [obj, obj2, obj3].sort
    end

    it "#pbt_valid_types returns strings of valid polymorphic record types" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Object")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Class")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Squishable")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Phone")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "GeoLocation")
      Squishy.pbt_valid_types.sort.must_equal ["Phone", "Address", "GeoLocation"].sort
    end

    it "#pbt_valid_types returns empty Array for no valid record types" do
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Object")
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Class")
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Squishable")
      Coffee.pbt_valid_types.to_a.sort.must_be :empty?
    end

    it "I'm just curious if polymorphic can belong to itself" do
      coffee = Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Coffee")
      coffee.must_be :valid?
      coffee.coffeeable_type.must_equal "Coffee"
      coffee.must_be :persisted?
    end

    it "#pbt_mistyped returns empty Array for no valid record types" do
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Phone")
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "Address")
      Coffee.create(Coffee.pbt_id_sym => 12_345, Coffee.pbt_type_sym => "User")
      Coffee.pbt_mistyped.to_a.sort.must_be :empty?
    end

    it "#pbt_mistypes returns empty Array if only valid polymorphic record types exist" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Phone")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "GeoLocation")
      Squishy.pbt_mistypes.sort.must_be :empty?
    end

    it "#pbt_poly_types returns strings of all polymorphic record types" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Object")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Class")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Squishable")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Phone")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address")
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "GeoLocation")
      Squishy.pbt_poly_types.sort.must_equal ["Phone", "Address", "GeoLocation", "Object", "Class", "Squishable"].sort
    end

    it "keeps helper methods private" do
      Squishy.singleton_class.private_method_defined?(:_pbt_polymorphic_orphans).must_be_same_as true
      Squishy.singleton_class.method_defined?(:_pbt_polymorphic_orphans).must_be_same_as false
      Squishy.method_defined?(:_pbt_polymorphic_orphans).must_be_same_as false
      Squishy.singleton_class.private_method_defined?(:_pbt_nonpolymorphic_orphans).must_be_same_as true
      Squishy.singleton_class.method_defined?(:_pbt_nonpolymorphic_orphans).must_be_same_as false
      Squishy.method_defined?(:_pbt_nonpolymorphic_orphans).must_be_same_as false
    end

    it "#orphan? gives boolean if record is orphaned" do
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Phone").must_be :orphan?
      Squishy.create(Squishy.pbt_id_sym => 12_345, Squishy.pbt_type_sym => "Address").must_be :orphan?
      User.create().wont_be :orphan?
      user = users(:bob)
      profile = user.profiles.build
      phone = profile.phones.build
      profile.save
      profile.wont_be :orphan?
      phone.wont_be :orphan?
      user.wont_be :orphan?
      Alpha.create.must_be :orphan?
    end

    describe "works with camelcase realtions" do
      it "pbt_parent snakecase to camelcase" do
        work_order = WorkOrder.create()
        e = Event.create(work_order: work_order)
        _(e.pbt_parent).must_equal work_order
      end

      it "pbt_parents snakecase to camelcase" do
        work_order = WorkOrder.create()
        e = Event.create(work_order: work_order)
        _(e.pbt_parents).must_include work_order
      end

      it "pbt_orphans snakecase to camelcase" do
        e = Event.create(work_order_id: 15)
        WorkOrder.destroy_all
        _(Event.pbt_orphans.pluck(:work_order_id).first).must_equal e.work_order_id
      end
    end
  end
end
