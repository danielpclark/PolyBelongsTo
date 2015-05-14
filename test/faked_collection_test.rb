require 'test_helper'
require 'minitest/autorun'

class FakedCollectionTest < ActiveSupport::TestCase
  fixtures :all

  let(:steve_photos){
    steve_prof = users(:steve).profiles.first
    PolyBelongsTo::FakedCollection.new(steve_prof, Photo)
  }
 
  let(:null_object){
    PolyBelongsTo::FakedCollection.new()
  }

  let(:nil_steve){
    PolyBelongsTo::FakedCollection.new(users(:steve), nil)
  }

  let(:nil_photo){
    PolyBelongsTo::FakedCollection.new(nil, Photo)
  }

  describe PolyBelongsTo::FakedCollection do

    it "#class.name is named correctly" do
      steve_photos.class.name.must_equal "PolyBelongsTo::FakedCollection" 
    end

    it "#superclass knows its superclass" do
      PolyBelongsTo::FakedCollection.superclass.must_equal Object
    end

    it "IDs the inner ited on :id" do
      [nil, photos(:steve_photo).id].must_include steve_photos.id
      nil_steve.id.must_be_nil
      nil_photo.id.must_be_nil
      null_object.id.must_be_nil
    end

    it "#all is an Array" do
      steve_photos.all.is_a?(              Array).must_be_same_as true
      steve_photos.all.must_be_kind_of(    Array)
      steve_photos.all.must_be_instance_of(Array)
      null_object.all.must_equal []
      nil_steve.all.must_equal   []
      nil_photo.all.must_equal   []
    end

    it "checks if #empty?" do
      steve_photos.wont_be :empty?
      null_object.must_be  :empty?
      nil_steve.must_be    :empty?
      nil_photo.must_be    :empty?
    end

    it "checks validity with #valid?" do
      steve_photos.must_be :valid?
      null_object.wont_be  :valid?
      nil_steve.wont_be    :valid?
      nil_photo.wont_be    :valid?
    end

    it "gives true or false on #present?" do
      steve_photos.must_be :present?
      null_object.wont_be  :present?
      nil_steve.wont_be    :present?
      nil_photo.wont_be    :present?
    end

    it "works with #presence" do
      steve_photos.presence.must_equal steve_photos
      null_object.presence.must_be_nil
      nil_steve.presence.must_be_nil
      nil_photo.presence.must_be_nil
    end

    it "#first is the item" do
      steve_photos.first.class.name.must_equal "Photo"
      null_object.first.must_be_nil
      nil_steve.first.must_be_nil
      nil_photo.first.must_be_nil
    end

    it "#last is the item" do
      steve_photos.last.class.name.must_equal "Photo"
      null_object.last.must_be_nil
      nil_steve.last.must_be_nil
      nil_photo.last.must_be_nil
    end

    it "#count and #size counts as 1 or 0" do
      steve_photos.count.between?(0,1).must_be_same_as true
      [0,1].must_include steve_photos.count
      null_object.count.must_be_same_as 0
      nil_steve.count.must_be_same_as   0
      nil_photo.count.must_be_same_as   0
      steve_photos.size.between?(0,1).must_be_same_as true
      [0,1].must_include steve_photos.size
      null_object.size.must_be_same_as  0
      nil_steve.size.must_be_same_as    0
      nil_photo.size.must_be_same_as    0
    end

    it "#ancestors has ActiveRecord::Base ancestor" do
      steve_photos.ancestors.must_include(ActiveRecord::Base)
    end

    it "#ancestors has NilClass if empty" do
      null_object.ancestors.must_include(NilClass)
      nil_steve.ancestors.must_include(NilClass)
      nil_photo.ancestors.must_include(NilClass)
    end

    it "build #kind_of? FakedCollection object" do
      steve_photos.must_be_kind_of(PolyBelongsTo::FakedCollection)
      null_object.must_be_kind_of(PolyBelongsTo::FakedCollection)
    end

    it "build #is_a? FakedCollection object" do
      steve_photos.is_a?(PolyBelongsTo::FakedCollection).must_be_same_as true
      null_object.is_a?(PolyBelongsTo::FakedCollection).must_be_same_as true
    end

    it "build #instance_of? FakedCollection object" do
      steve_photos.must_be_instance_of(PolyBelongsTo::FakedCollection)
      null_object.must_be_instance_of(PolyBelongsTo::FakedCollection)
    end
    
    it "#build builds appropriately" do
      steve_photos.build({content: "cheese"})
      steve_photos.first.content.must_equal "cheese"
      ->{ null_object.build({content: "cheese"}) }.must_raise TypeError
      ->{ nil_steve.build(  {content: "cheese"}) }.must_raise TypeError
      ->{ nil_photo.build(  {content: "cheese"}) }.must_raise TypeError
    end

    it "#build returns self and not nil" do
      res = steve_photos.build({content: "cheese"})
      res.wont_be_nil
      res.class.name.must_equal steve_photos.class.name
      res.first.content.must_equal "cheese"
      steve_photos.first.content.must_equal "cheese"
    end

    it "#each loops appropriately" do
      steve_photos.each do |photo|
        photo.class.name.must_equal "Photo"
      end
    end

    it "defines #klass to point to inner items class" do
      steve_photos.klass.name.must_equal "Photo"
    end

    it "#respond_to? :first and :last" do
      steve_photos.must_respond_to(:first)
      steve_photos.must_respond_to(:last)
    end

    it "knows sneeze is a missing method" do
      ->{steve_photos.sneeze}.must_raise NoMethodError
    end

    it "has method_missing forward appropriate calls" do
      steve_photos.method_missing(:nil?).must_equal false
      null_object.method_missing(:nil?).must_equal true
    end

    it "will not initialize on has_many" do
      steve = users(:steve)
      ->{ PolyBelongsTo::FakedCollection.new(steve, Profile) }.must_raise RuntimeError 
    end

    it "takes nil Objects and returns an empty FakedCollection" do
      nil_photo.must_be :empty?
      nil_photo.all.must_equal []
      nil_photo.size.must_be_same_as 0
      nil_photo.instance_eval {@instance}.must_be_nil
      nil_photo.wont_be :valid?
      
      nil_steve.all.must_equal []
      nil_steve.size.must_be_same_as 0
      nil_steve.must_be :empty?
      nil_steve.instance_eval {@instance}.must_be_nil
      nil_steve.wont_be :valid?

      null_object.all.must_equal []
      null_object.size.must_be_same_as 0
      null_object.must_be :empty?
      null_object.instance_eval {@instance}.must_be_nil
      null_object.wont_be :valid?
    end

  end

end
