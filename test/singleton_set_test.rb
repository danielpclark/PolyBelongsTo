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
  end
end
