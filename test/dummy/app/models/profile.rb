class Profile < ActiveRecord::Base
  belongs_to :profileable, polymorphic: true
  has_many   :phones, as: :phoneable, dependent: :destroy
  has_many   :addresses, as: :addressable, dependent: :destroy
  has_one    :photo, as: :photoable, dependent: :destroy
  accepts_nested_attributes_for :phones, :addresses, :photo
end
