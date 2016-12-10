require "test_helper"

class HmtAssemblyTest < ActiveSupport::TestCase

  def hmt_assembly
    @hmt_assembly ||= HmtAssembly.new
  end

  def test_valid
    assert hmt_assembly.valid?
  end

end
