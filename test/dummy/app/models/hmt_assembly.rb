class HmtAssembly < ActiveRecord::Base
  has_many :manifests
  has_many :hmt_parts, through: :manifests
end
