require 'test_helper'
require 'minitest/autorun'

class DupTest < ActiveSupport::TestCase
  fixtures :all

  describe PolyBelongsTo::SingletonSet do
    let (:example) { users(:bob) }
    let (:the_set) { PolyBelongsTo::SingletonSet.new }
    
    it "formats name with #formatted_name" do
      the_set.formatted_name(example).must_equal "#{example.class.name}-#{example.id}"
    end

    it "adds with :add?" do
      the_set.add?(example)
      the_set.to_a.must_equal ["#{example.class.name}-#{example.id}"]
    end
    it "adds with :add" do
      the_set.add(example)
      the_set.to_a.must_equal ["#{example.class.name}-#{example.id}"]
    end
    it "adds with :<<" do
      the_set.<<(example)
      the_set.to_a.must_equal ["#{example.class.name}-#{example.id}"]
    end

    it "flags a duplicate" do
      the_set.<<(example)
      the_set.<<(example).must_be_nil
      the_set.flagged?(example).must_be_same_as true
      the_set.instance_eval {@flagged}.to_a.must_equal ["#{example.class.name}-#{example.id}"]
    end

    it "says false for unflagged items" do
      the_set.flagged?(example).must_be_same_as false
    end
  end
end
