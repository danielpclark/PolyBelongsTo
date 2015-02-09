# Poly Belongs To
# The MIT License (MIT)
# Copyright (C) 2015 by Daniel P. Clark
$: << File.join(File.dirname(__FILE__), "/poly_belongs_to")
require 'poly_belongs_to/version'
require 'active_support/concern'

module PolyBelongsTo
  extend ActiveSupport::Concern

  included do
    def self.pbt
      reflect_on_all_associations(:belongs_to).first.try(:name)
    end
    
    def self.poly?
      !!reflect_on_all_associations(:belongs_to).first.try {|i| i.options[:polymorphic] }
    end
  end
  
  def pbt
    self.class.pbt
  end

  def poly?
    self.class.poly?
  end

  def pbt_id
    val = pbt
    val ? eval("self.#{val}_id") : nil
  end

  def pbt_type
    val = pbt
    val ? eval("self.#{val}_type") : nil
  end

end

ActiveRecord::Base.send(:include, PolyBelongsTo)
