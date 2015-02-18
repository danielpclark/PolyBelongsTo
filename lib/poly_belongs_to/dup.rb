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
        built = pbt_dup_build(item_to_build, item_to_duplicate)
        
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
