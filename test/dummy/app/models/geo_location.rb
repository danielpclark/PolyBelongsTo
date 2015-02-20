class GeoLocation < ActiveRecord::Base
  belongs_to :address
  has_many :squishies, as: :squishable, dependent: :destroy
end
