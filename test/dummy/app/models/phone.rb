class Phone < ActiveRecord::Base
  belongs_to :phoneable, polymorphic: true
  has_one :squishy, as: :squishable, dependent: :destroy
end
