module PolyBelongsTo
  module Core
    extend ActiveSupport::Concern

    included do
      def self.pbt
        reflect_on_all_associations(:belongs_to).first.try(:name)
      end

      def self.pbts
        reflect_on_all_associations(:belongs_to).map(&:name)
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

    def pbts
      self.class.pbts
    end
    
    def poly?
      self.class.poly?
    end

    def pbt_id
      val = pbt
      val ? self.send("#{val}_id") : nil
    end

    def pbt_type
      poly? ? self.send("#{pbt}_type") : nil
    end

    def pbt_parent
      val = pbt
      if val && !pbt_id.nil?
        if poly?
          "#{pbt_type}".constantize.find(pbt_id)
        else
          "#{val.capitalize}".constantize.find(pbt_id)
        end
      else
        nil
      end
    end

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

    def pbt_parents
      if poly?
        Array[pbt_parent].compact
      else
        self.class.pbts.map {|i|
          try{ "#{i.capitalize}".constantize.find(self.send("#{i}_id")) }
        }.compact
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
