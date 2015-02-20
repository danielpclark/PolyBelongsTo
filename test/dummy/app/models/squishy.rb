class Squishy < ActiveRecord::Base
  belongs_to :squishable, polymorphic: true
end
