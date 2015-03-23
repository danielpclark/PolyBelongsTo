class Beta < ActiveRecord::Base
  belongs_to :alpha
  has_many :capas
end
