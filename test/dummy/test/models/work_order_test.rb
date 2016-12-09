require "test_helper"

class WorkOrderTest < ActiveSupport::TestCase

  def work_order
    @work_order ||= WorkOrder.new
  end

  def test_valid
    assert work_order.valid?
  end

end
