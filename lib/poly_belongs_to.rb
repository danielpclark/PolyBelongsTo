# Poly Belongs To
# The MIT License (MIT)
# Copyright (C) 2015 by Daniel P. Clark
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

