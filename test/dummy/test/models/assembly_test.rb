require "test_helper"

class AssemblyTest < ActiveSupport::TestCase

  def assembly
    @assembly ||= Assembly.new
  end

  def test_valid
    assert assembly.valid?
  end

end
