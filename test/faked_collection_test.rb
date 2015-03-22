require 'test_helper'
require 'minitest/autorun'

class FakedCollectionTest < ActiveSupport::TestCase
  fixtures :all

  let(:steve_photos){
    steve_prof = users(:steve).profiles.first
    PolyBelongsTo::FakedCollection.new(steve_prof, Photo)
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
    end

    it "#all is an Array" do
      steve_photos.all.is_a?(Array).must_be_same_as true
      steve_photos.all.must_be_kind_of(Array)
      steve_photos.all.must_be_instance_of(Array)
    end

    it "#first is the item" do
      steve_photos.first.class.name.must_equal "Photo"
    end

    it "#last is the item" do
      steve_photos.last.class.name.must_equal "Photo"
    end

    it "#count and #size counts as 1 or 0" do
      steve_photos.count.between?(0,1).must_be_same_as true
      [0,1].must_include steve_photos.count
      steve_photos.size.between?(0,1).must_be_same_as true
      [0,1].must_include steve_photos.size
    end

    it "#ancestors has ActiveRecord::Base ancestor" do
      steve_photos.ancestors.must_include(ActiveRecord::Base)
    end

    it "build #kind_of? FakedCollection object" do
      steve_photos.must_be_kind_of(PolyBelongsTo::FakedCollection)
    end

    it "build #is_a? FakedCollection object" do
      steve_photos.is_a?(PolyBelongsTo::FakedCollection).must_be_same_as true
    end

    it "build #instance_of? FakedCollection object" do
      steve_photos.must_be_instance_of(PolyBelongsTo::FakedCollection)
    end
    
    it "#build builds appropriately" do
      steve_photos.build({content: "cheese"})
      steve_photos.first.content.must_equal "cheese"
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

    it "will not initialize on has_many" do
      steve = users(:steve)
      ->{ PolyBelongsTo::FakedCollection.new(steve, Profile) }.must_raise RuntimeError 
    end

  end

end
