class WorkOrder < ActiveRecord::Base
  has_many :events, dependent: :destroy
end
