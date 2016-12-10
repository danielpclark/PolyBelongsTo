require "test_helper"

class HmtPartTest < ActiveSupport::TestCase

  def hmt_part
    @hmt_part ||= HmtPart.new
  end

  def test_valid
    assert hmt_part.valid?
  end

end
