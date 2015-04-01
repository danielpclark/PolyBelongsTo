$: << File.join(File.dirname(__FILE__), "/poly_belongs_to")
require 'active_support/concern'
require 'poly_belongs_to/version'
require 'poly_belongs_to/core'
require 'poly_belongs_to/singleton_set'
require 'poly_belongs_to/dup'
require 'poly_belongs_to/pbt'
require 'poly_belongs_to/faked_collection'
ActiveRecord::Base.send(:include, PolyBelongsTo::Core )
ActiveRecord::Base.send(:include, PolyBelongsTo::Dup  )



##
#
# PolyBelongsTo
# @author Daniel P. Clark
#
# Creates uniform helper methods on all ActiveModel & ActiveRecord instances
# to allow universal access and control over (most) any kind of database
# relationship.
#
# PolyBelongsTo::Core and PolyBelongsTo::Dup methods are included on each instance.
# @see PolyBelongsTo::Core
# @see PolyBelongsTo::Dup
#
module PolyBelongsTo end
