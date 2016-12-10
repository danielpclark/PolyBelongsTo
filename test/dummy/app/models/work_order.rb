class WorkOrder < ActiveRecord::Base
  has_many :events, dependent: :destroy
  belongs_to :big_company
end
