require "test_helper"

class AddressBookTest < ActiveSupport::TestCase

  def address_book
    @address_book ||= AddressBook.new
  end

  def test_valid
    assert address_book.valid?
  end

end
