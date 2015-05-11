class Coffee < ActiveRecord::Base
  belongs_to :coffeeable, polymorphic: true
  has_many :coffees, as: :coffeeable, dependent: :destroy
end
