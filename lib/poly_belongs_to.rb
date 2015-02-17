# Poly Belongs To
# The MIT License (MIT)
# Copyright (C) 2015 by Daniel P. Clark
$: << File.join(File.dirname(__FILE__), "/poly_belongs_to")
require 'poly_belongs_to/version'
require 'poly_belongs_to/dup'
require 'poly_belongs_to/hierarchy'
require 'active_support/concern'

module PolyBelongsTo
  module Core
    extend ActiveSupport::Concern

    included do
      def self.pbt
        reflect_on_all_associations(:belongs_to).first.try(:name)
      end
      
      def self.poly?
        !!reflect_on_all_associations(:belongs_to).first.try {|i| i.options[:polymorphic] }
      end

      def self.pbt_params_name(allow_as_nested = true)
        if poly?
          allow_as_nested ? "#{table_name}_attributes".to_sym : name.downcase.to_sym
        else
          name.downcase.to_sym
        end
      end

      def self.pbt_id_sym
        val = pbt
        val ? "#{val}_id".to_sym : nil
      end

      def self.pbt_type_sym
        poly? ? "#{pbt}_type".to_sym : nil
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
      poly? ? eval("self.#{pbt}_type") : nil
    end

    def pbt_parent
      val = pbt
      if val
        if poly?
          eval "#{pbt_type}.find(#{pbt_id})"
        else
          eval "#{val.capitalize.to_s}.find(#{pbt_id})"
        end
      else
        nil
      end
    end

    def pbt_id_sym
      self.class.pbt_id_sym
    end

    def pbt_type_sym
      self.class.pbt_type_sym
    end

    def pbt_params_name(allow_as_nested = true)
      self.class.pbt_params_name(allow_as_nested)
    end
  end
end

ActiveRecord::Base.send(:include, PolyBelongsTo::Core)
