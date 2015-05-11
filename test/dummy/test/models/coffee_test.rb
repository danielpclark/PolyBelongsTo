require "test_helper"

class CoffeeTest < ActiveSupport::TestCase

  def coffee
    @coffee ||= Coffee.new
  end

  def test_valid
    assert coffee.valid?
  end

end
