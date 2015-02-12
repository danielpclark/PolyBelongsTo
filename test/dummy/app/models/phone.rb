class Phone < ActiveRecord::Base
  belongs_to :phoneable, polymorphic: true
end
