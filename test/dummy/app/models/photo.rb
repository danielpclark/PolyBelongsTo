class Photo < ActiveRecord::Base
  belongs_to :photoable, polymorphic: true
end
