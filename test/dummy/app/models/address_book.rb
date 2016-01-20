class AddressBook < ActiveRecord::Base
  has_many :contacts, as: :contactable, dependent: :destroy
end
