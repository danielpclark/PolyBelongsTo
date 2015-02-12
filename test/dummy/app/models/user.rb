class User < ActiveRecord::Base
  has_many :tags, dependent: :destroy
  has_many :phones, as: :phoneable, dependent: :destroy
end
