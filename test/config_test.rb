require 'test_helper'
require 'minitest/autorun'

class ConfigTest < ActiveSupport::TestCase
  describe "The configuration option" do
    it "takes in configuration values" do
      PolyBelongsTo.config.max_recurse = 42
      PolyBelongsTo.config.max_recurse.must_equal 42
    end
  end
end
