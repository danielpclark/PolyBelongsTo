require "test_helper"

class EventTest < ActiveSupport::TestCase

  def event
    @event ||= Event.new
  end

  def test_valid
    assert event.valid?
  end

end
