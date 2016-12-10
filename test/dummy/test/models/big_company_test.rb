require "test_helper"

class BigCompanyTest < ActiveSupport::TestCase

  def big_company
    @big_company ||= BigCompany.new
  end

  def test_valid
    assert big_company.valid?
  end

end
