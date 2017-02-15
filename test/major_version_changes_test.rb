require 'test_helper'
require 'minitest/autorun'

class MajorVersionChangesTest < ActiveSupport::TestCase
  fixtures :all

  describe "Test breaking changes between major versions" do

    let(:contact) { contacts(:bob_contact) }

    if Gem::Dependency.new('', "< 1.0.0").match?('', PolyBelongsTo::VERSION)
      it "pre 1.0.0 first parent relation" do
        contact.pbt.must_be_same_as :user
        Contact.pbt.must_be_same_as :user

        contact.pbts.must_include :user
        contact.pbts.must_include :contactable
        contact.pbts.first.must_be_same_as :user
        Contact.pbts.must_include :user
        Contact.pbts.must_include :contactable
        Contact.pbts.first.must_be_same_as :user
      end
      
      it "pre 1.0.0 :poly? on dual ownership with non-polymorphic first" do
        contact.poly?.must_be_same_as false
        Contact.poly?.must_be_same_as false
      end

      it "pre 1.0.0 :pbt_type_sym on dual ownership with non-polymorphic first" do
        contact.pbt_id_sym.must_be_same_as :user_id
        Contact.pbt_id_sym.must_be_same_as :user_id
      end

      it "pre 1.0.0 :pbt_parent returns first parent" do
        contact.pbt_parent.id.must_be_same_as users(:bob).id
      end
    else
      it "post 1.0.0 first polymorphic parent relation" do
        contact.pbt.must_be_same_as :contactable
        Contact.pbt.must_be_same_as :contactable

        contact.pbts.must_include :user
        contact.pbts.must_include :contactable
        contact.pbts.first.must_be_same_as :contactable
        Contact.pbts.must_include :user
        Contact.pbts.must_include :contactable
        Contact.pbts.first.must_be_same_as :contactable
      end

      it "post 1.0.0 :poly? on dual ownership with non-polymorphic first" do
        contact.poly?.must_be_same_as true
        Contact.poly?.must_be_same_as true
      end

      it "pre 1.0.0 :pbt_type_sym on dual ownership with non-polymorphic first" do
        contact.pbt_id_sym.must_be_same_as :contactable_id
        Contact.pbt_id_sym.must_be_same_as :contactable_id
      end

      it "post 1.0.0 :pbt_parent gives polymorphic parent precedence" do
        contact.pbt_parent.id.wont_equal users(:bob).id
      end
    end
  end
end
