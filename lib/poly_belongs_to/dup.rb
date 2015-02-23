module PolyBelongsTo
  module Dup
    extend ActiveSupport::Concern

    included do
      def self.pbt_dup_build(item_to_build_on, item_to_duplicate)
        if PolyBelongsTo::Pbt::IsReflected[item_to_build_on, item_to_duplicate]
          PolyBelongsTo::Pbt::AsCollectionProxy[item_to_build_on, item_to_duplicate].
            build PolyBelongsTo::Pbt::AttrSanitizer[item_to_duplicate]
        end
      end

      def self.pbt_deep_dup_build(item_to_build_on, item_to_duplicate)
        pbt_dup_build(item_to_build_on, item_to_duplicate)
        PolyBelongsTo::Pbt::Reflects[item_to_duplicate].each do |ref|
          child = eval("item_to_duplicate.#{ref}")
          PolyBelongsTo::Pbt::AsCollectionProxy[item_to_build_on, item_to_duplicate].
            each do |builder|
              child.respond_to?(:build) ? child.each {|spawn|
                builder.pbt_deep_dup_build(spawn)
              } : builder.pbt_deep_dup_build(child)
            end
        end
        item_to_build_on       
      end

   end

    def pbt_dup_build(item_to_duplicate)
      self.class.pbt_dup_build(self, item_to_duplicate)
    end

    def pbt_deep_dup_build(item_to_duplicate)
      self.class.pbt_deep_dup_build(self, item_to_duplicate)
    end

  end
end
