require 'test_helper'
require 'minitest/autorun'

class PbtTest < ActiveSupport::TestCase
  fixtures :all

  it "AttrSanitizer removes conflicting attributes" do
    user = users(:bob)
    PolyBelongsTo::Pbt::AttrSanitizer[user].must_equal Hash[id: nil, content: user.content].stringify_keys
    PolyBelongsTo::Pbt::AttrSanitizer[nil ].must_equal Hash[] 
  end

  it "BuildCmd returns build command" do
    profile = profiles(:bob_prof)
    "#{PolyBelongsTo::Pbt::BuildCmd[profile,Phone]}".must_equal "phones.build"
    "#{PolyBelongsTo::Pbt::BuildCmd[profile,Photo]}".must_equal "build_photo"
    PolyBelongsTo::Pbt::BuildCmd[nil,       Photo].must_be_nil
    PolyBelongsTo::Pbt::BuildCmd[profile,     nil].must_be_nil
  end

  it "Reflects retruns has_one and has_many relationships" do
    profile = profiles(:bob_prof)
    PolyBelongsTo::Pbt::Reflects[profile].sort.must_equal [:phones, :addresses, :photo].sort
    PolyBelongsTo::Pbt::Reflects[nil    ].must_equal Array[]
  end

  it "ReflectsAsClasses one and many relations as classes" do
    profile = profiles(:bob_prof)
    PolyBelongsTo::Pbt::ReflectsAsClasses[profile].map(&:hash).sort.must_equal [Phone, Address, Photo].map(&:hash).sort
    PolyBelongsTo::Pbt::ReflectsAsClasses[nil    ].must_equal Array[]
  end

  it "IsReflected gives boolean of child" do
    profile = profiles(:bob_prof)
    PolyBelongsTo::Pbt::IsReflected[profile,  Phone].must_equal true
    PolyBelongsTo::Pbt::IsReflected[profile,Address].must_equal true
    PolyBelongsTo::Pbt::IsReflected[profile,  Photo].must_equal true
    PolyBelongsTo::Pbt::IsReflected[profile,   User].must_equal false
    PolyBelongsTo::Pbt::IsReflected[nil,       User].must_equal false
    PolyBelongsTo::Pbt::IsReflected[profile,    nil].must_equal false
  end

  it "SingularOrPlural responds for child relations" do
    profile = profiles(:susan_prof)
    PolyBelongsTo::Pbt::SingularOrPlural[profile,Phone].must_equal :plural
    PolyBelongsTo::Pbt::SingularOrPlural[profile,Photo].must_equal :singular
    PolyBelongsTo::Pbt::SingularOrPlural[profile, User].must_be_nil
    PolyBelongsTo::Pbt::SingularOrPlural[nil,     User].must_be_nil
    PolyBelongsTo::Pbt::SingularOrPlural[profile,  nil].must_be_nil
  end

  it "IsSingular tells child singleness" do
    profile = profiles(:steve_prof)
    PolyBelongsTo::Pbt::IsSingular[profile,Phone].must_be_same_as false
    PolyBelongsTo::Pbt::IsSingular[nil,    Phone].must_be_same_as false
    PolyBelongsTo::Pbt::IsSingular[profile,  nil].must_be_same_as false
    PolyBelongsTo::Pbt::IsSingular[profile,Photo].must_be_same_as true
  end

  it "IsPlural tells child pluralness" do
    profile = profiles(:bob_prof)
    PolyBelongsTo::Pbt::IsPlural[profile,Phone].must_be_same_as true
    PolyBelongsTo::Pbt::IsPlural[profile,Photo].must_be_same_as false
    PolyBelongsTo::Pbt::IsPlural[nil,    Photo].must_be_same_as false
    PolyBelongsTo::Pbt::IsPlural[profile,  nil].must_be_same_as false
  end

  it "CollectionProxy: singular or plural proxy name" do
    profile = profiles(:steve_prof)
    PolyBelongsTo::Pbt::CollectionProxy[profile,Phone].must_equal :phones
    PolyBelongsTo::Pbt::CollectionProxy[profile,Photo].must_equal :photo
    PolyBelongsTo::Pbt::CollectionProxy[profile, User].must_be_nil
    PolyBelongsTo::Pbt::CollectionProxy[nil,     User].must_be_nil
    PolyBelongsTo::Pbt::CollectionProxy[profile,  nil].must_be_nil
  end
end