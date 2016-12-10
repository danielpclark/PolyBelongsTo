require "test_helper"

class PartTest < ActiveSupport::TestCase

  def part
    @part ||= Part.new
  end

  def test_valid
    assert part.valid?
  end

end
