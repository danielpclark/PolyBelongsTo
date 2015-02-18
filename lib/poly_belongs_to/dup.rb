module PolyBelongsTo
  module Dup
    extend ActiveSupport::Concern

    included do
      def self.pbt_dup_build(item_to_build_on, item_to_duplicate)
        if PolyBelongsTo::Pbt::IsReflected[item_to_build_on, item_to_duplicate]
          build_cmd = PolyBelongsTo::Pbt::BuildCmd[item_to_build_on, item_to_duplicate]
          dup_attrs = PolyBelongsTo::Pbt::AttrSanitizer[item_to_duplicate]

          build_cmd ? eval("item_to_build_on.#{build_cmd}(#{dup_attrs})") : nil
        end
      end

      def self.pbt_deep_dup_build(item_to_build_on, item_to_duplicate)
        pbt_dup_build(item_to_build_on, item_to_duplicate)
        PolyBelongsTo::Pbt::Reflects[item_to_duplicate].each do |ref|
          child = eval("item_to_duplicate.#{ref}")
          function = "item_to_build_on.#{PolyBelongsTo::Pbt::CollectionProxy[item_to_build_on, item_to_duplicate]}"
          if child.respond_to?(:build)
            child.each do |obj|
              eval(function).pbt_deep_dup_build(obj)
            end
          else
            eval(function).pbt_deep_dup_build(child)
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
