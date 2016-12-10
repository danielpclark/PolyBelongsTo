class HmtPart < ActiveRecord::Base
  has_many :manifests
  has_many :hmt_assemblies, through: :manifests
end
