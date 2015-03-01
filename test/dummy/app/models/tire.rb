class Tire < ActiveRecord::Base
  belongs_to :user
  belongs_to :car
end
