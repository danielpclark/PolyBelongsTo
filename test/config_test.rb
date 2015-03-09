require 'test_helper'
require 'minitest/autorun'

class ConfigTest < ActiveSupport::TestCase
  describe PolyBelongsTo do
    describe "config" do
      it "takes in configuration values" do
        PolyBelongsTo.config.max_recurse = 42
        PolyBelongsTo.config.max_recurse.must_equal 42
      end

      it "can have internal default methods using singleton method #fetch" do
        class << PolyBelongsTo.config
          def example
            fetch(__method__) { 42 }
          end
        end
        PolyBelongsTo.config.example.must_equal 42
        PolyBelongsTo.config.example = 53
        PolyBelongsTo.config.example.must_equal 53
        PolyBelongsTo.config.delete('example')
        PolyBelongsTo.config.example.must_equal 42
        PolyBelongsTo.config.example = 53
        PolyBelongsTo.config.example.must_equal 53
      end
    end
  end
end
