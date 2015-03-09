require 'test_helper'
require 'minitest/autorun'

class FakedCollectionTest < ActiveSupport::TestCase
  fixtures :all

  let(:photos){
    steve_prof = users(:steve).profiles.first
    PolyBelongsTo::FakedCollection.new(steve_prof, Photo)
  }

  describe PolyBelongsTo::FakedCollection do

    it "#class.name is named correctly" do
      photos.class.name.must_equal "PolyBelongsTo::FakedCollection" 
    end

    it "#superclass knows its superclass" do
      PolyBelongsTo::FakedCollection.superclass.must_equal Object
    end

    it "#all is an Array" do
      photos.all.is_a?(Array).must_be_same_as true
      photos.all.kind_of?(Array).must_be_same_as true
    end

    it "#first is the item" do
      photos.first.class.name.must_equal "Photo"
    end

    it "#last is the item" do
      photos.last.class.name.must_equal "Photo"
    end

    it "#count and #size counts as 1 or 0" do
      photos.count.between?(0,1).must_be_same_as true
      photos.size.between?(0,1).must_be_same_as true
    end

    it "#ancestors has ActiveRecord::Base ancestor" do
      photos.ancestors.include?(ActiveRecord::Base).must_be_same_as true
    end

    it "build #kind_of? FakedCollection object" do
      photos.kind_of?(PolyBelongsTo::FakedCollection).must_be_same_as true
    end

    it "build #is_a? FakedCollection object" do
      photos.is_a?(PolyBelongsTo::FakedCollection).must_be_same_as true
    end

    it "build #instance_of? FakedCollection object" do
      photos.instance_of?(PolyBelongsTo::FakedCollection).must_be_same_as true
    end
    
    it "#build builds appropriately" do
      photos.build({content: "cheese"})
      photos.first.content.must_equal "cheese"
    end

    it "#build returns self and not nil" do
      res = photos.build({content: "cheese"})
      res.wont_be_nil
      res.class.name.must_equal photos.class.name
      res.first.content.must_equal "cheese"
      photos.first.content.must_equal "cheese"
    end

    it "#each loops appropriately" do
      photos.each do |photo|
        photo.class.name.must_equal "Photo"
      end
    end

    it "defines #klass to point to inner items class" do
      photos.klass.name.must_equal "Photo"
    end

    it "#respond_to? :first and :last" do
      photos.respond_to?(:first).must_be_same_as true
      photos.respond_to?(:last).must_be_same_as true
    end

    it "knows sneeze is a missing method" do
      ->{photos.sneeze}.must_raise NoMethodError
    end

    it "will not initialize on has_many" do
      steve = users(:steve)
      ->{ PolyBelongsTo::FakedCollection.new(steve, Profile) }.must_raise RuntimeError 
    end

  end

end
