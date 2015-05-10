module PolyBelongsTo
  ##
  # PolyBelongsTo::Core are the core set of methods included on all ActiveModel & ActiveRecord instances.
  module Core
    extend ActiveSupport::Concern

    included do
      # @return [Symbol, nil] first belongs_to relation
      def self.pbt
        reflect_on_all_associations(:belongs_to).first.try(:name)
      end

      # @return [Array<Symbol>] belongs_to relations
      def self.pbts
        reflect_on_all_associations(:belongs_to).map(&:name)
      end
      
      # Boolean reponse of current class being polymorphic
      # @return [true, false]
      def self.poly?
        !!reflect_on_all_associations(:belongs_to).first.try {|i| i.options[:polymorphic] }
      end

      # Symbol for html form params
      # @param allow_as_nested [true, false] Allow parameter name to be nested attribute symbol
      # @return [Symbol] The symbol for the form in the view
      def self.pbt_params_name(allow_as_nested = true)
        if poly? && allow_as_nested
          "#{table_name}_attributes".to_sym
        else
          name.downcase.to_sym
        end
      end

      # The symbol as an id field for the first belongs_to relation
      # @return [Symbol, nil] :`belongs_to_object`_id or nil
      def self.pbt_id_sym
        val = pbt
        val ? "#{val}_id".to_sym : nil
      end

      # The symbol as an sym field for the polymorphic belongs_to relation, or nil
      # @return [Symbol, nil] :`belongs_to_object`_sym or nil
      def self.pbt_type_sym
        poly? ? "#{pbt}_type".to_sym : nil
      end

      # Returns an unique array of strings of every polymorphic record type
      # @return [Array<String>]
      def self.pbt_poly_types
        return [] unless poly?
        uniq.pluck(pbt_type_sym)
      end

      # Returns strings of the invalid class names stored in polymorphic records
      # @return [Array<String>]
      def self.pbt_mistypes
        pbt_poly_types.select {|i| 
          begin !i.constantize.respond_to?(:pluck) rescue true end
        }
      end
      
      # Returns strings of the valid class names stored in polymorphic records
      # @return [Array<String>]
      def self.pbt_valid_types
        pbt_poly_types.delete_if {|i| 
          begin !i.constantize.respond_to?(:pluck) rescue true end
        }
      end

      # Returns records with invalid class names stored in polymorphic records
      # @return [Array<Object>, nil] ActiveRecord mistyped objects
      def self.pbt_mistyped
        return nil unless poly?
        where(pbt_type_sym => pbt_mistypes)
      end

      # Return Array of current Class records that are orphaned from parents
      # @return [Array<Object>, nil] ActiveRecord orphan objects
      def self.pbt_orphans
        return nil unless pbts.present?
        poly? ? _pbt_polymorphic_orphans : _pbt_nonpolymorphic_orphans
      end
      
      private
      # Return Array of current Class polymorphic records that are orphaned from parents
      # @return [Array<Object>] ActiveRecord orphan objects
      def self._pbt_polymorphic_orphans
        accumulative = nil
        pbt_valid_types.each do |type|
          arel_part = arel_table[pbt_id_sym].not_in(type.constantize.pluck(:id)).and(arel_table[pbt_type_sym].eq(type))
          accumulative = accumulative.present? ? accumulative.or(arel_part) : arel_part
        end
        where(accumulative)
      end

      # Return Array of current Class nonpolymorphic records that are orphaned from parents
      # @return [Array<Object>] ActiveRecord orphan objects
      def self._pbt_nonpolymorphic_orphans
        where(["#{pbt_id_sym} NOT IN (?)", pbt.to_s.capitalize.constantize.pluck(:id)])
      end
      class << self
        private :_pbt_polymorphic_orphans
        private :_pbt_nonpolymorphic_orphans
      end
    end
    
    # @return [Symbol, nil] first belongs_to relation
    def pbt
      self.class.pbt
    end

    # @return [Array<Symbol>] belongs_to relations
    def pbts
      self.class.pbts
    end
    
    # Boolean reponse of current class being polymorphic
    # @return [true, false]
    def poly?
      self.class.poly?
    end

    # Value of parent id.  nil if no parent
    # @return [Integer, nil]
    def pbt_id
      val = pbt
      val ? self.send("#{val}_id") : nil
    end

    # Value of polymorphic relation type.  nil if not polymorphic.
    # @return [String, nil]
    def pbt_type
      poly? ? self.send("#{pbt}_type") : nil
    end

    # Get the parent relation.  Polymorphic relations are prioritized first.
    # @return [Object, nil] ActiveRecord object instasnce
    def pbt_parent
      val = pbt
      if val && !pbt_id.nil?
        if poly?
          "#{pbt_type}".constantize.where(id: pbt_id).first
        else
          "#{val.capitalize}".constantize.where(id: pbt_id).first
        end
      else
        nil
      end
    end

    # Climb up each parent object in the hierarchy until the top is reached.
    #   This has a no-repeat safety built in.  Polymorphic parents have priority.
    # @return [Object, nil] top parent ActiveRecord object instace
    def pbt_top_parent
      record = self
      return nil unless record.pbt_parent
      no_repeat = PolyBelongsTo::SingletonSet.new
      while !no_repeat.include?(record.pbt_parent) && !record.pbt_parent.nil?
        no_repeat.add?(record)
        record = record.pbt_parent
      end
      record
    end

    # All belongs_to parents as class objects. One if polymorphic.
    # @return [Array<Object>] ActiveRecord classes of parent objects.
    def pbt_parents
      if poly?
        Array[pbt_parent].compact
      else
        self.class.pbts.map {|i|
          try{ "#{i.capitalize}".constantize.where(id: self.send("#{i}_id")).first }
        }.compact
      end
    end

    # The symbol as an id field for the first belongs_to relation
    # @return [Symbol, nil] :`belongs_to_object`_id or nil
    def pbt_id_sym
      self.class.pbt_id_sym
    end

    # The symbol as an sym field for the polymorphic belongs_to relation, or nil
    # @return [Symbol, nil] :`belongs_to_object`_sym or nil
    def pbt_type_sym
      self.class.pbt_type_sym
    end

    # Symbol for html form params
    # @param allow_as_nested [true, false] Allow parameter name to be nested attribute symbol
    # @return [Symbol] The symbol for the form in the view
    def pbt_params_name(allow_as_nested = true)
      self.class.pbt_params_name(allow_as_nested)
    end

    # Return true or false on whether the record is orphaned
    # @return [Boolean
    def orphan?
      pbts.present? && !pbt_parent.present?
    end
  end
end
