class User < ActiveRecord::Base
  has_one  :ssn, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :profiles, as: :profileable, dependent: :destroy
end
