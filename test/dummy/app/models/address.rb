class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  has_one :geo_location
  has_many :squishies, as: :squishable, dependent: :destroy
end
