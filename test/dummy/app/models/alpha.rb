class Alpha < ActiveRecord::Base
  belongs_to :delta
  has_many :betas
end
