class Capa < ActiveRecord::Base
  belongs_to :beta
  has_many :deltas
end
