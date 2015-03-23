class Delta < ActiveRecord::Base
  belongs_to :capa
  has_many :alphas
end
