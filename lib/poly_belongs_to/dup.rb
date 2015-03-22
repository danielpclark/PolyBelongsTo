module PolyBelongsTo
  module Dup
    extend ActiveSupport::Concern

    included do
      def self.pbt_dup_build(item_to_build_on, item_to_duplicate)
        singleton_record = yield if block_given? 
        if PolyBelongsTo::Pbt::IsReflected[item_to_build_on, item_to_duplicate]
          PolyBelongsTo::Pbt::AsCollectionProxy[item_to_build_on, item_to_duplicate].
            build PolyBelongsTo::Pbt::AttrSanitizer[item_to_duplicate] if (
              block_given? ? singleton_record.add?(item_to_duplicate) : true)
        end
      end

      def self.pbt_deep_dup_build(item_to_build_on, item_to_duplicate)
        singleton_record = (block_given? ? yield : PolyBelongsTo::SingletonSet.new)
        pbt_dup_build(item_to_build_on, item_to_duplicate) {singleton_record}
        PolyBelongsTo::Pbt::Reflects[item_to_duplicate].each do |ref|
          child = item_to_duplicate.send(ref)
          PolyBelongsTo::Pbt::AsCollectionProxy[item_to_build_on, item_to_duplicate].
            each do |builder|
              child.respond_to?(:build) ? child.each {|spawn|
                builder.pbt_deep_dup_build(spawn) {singleton_record}
              } : builder.pbt_deep_dup_build(child) {singleton_record}
          end unless singleton_record.flagged?(item_to_build_on)
        end
        item_to_build_on       
      end

   end

    def pbt_dup_build(item_to_duplicate, &block)
      self.class.pbt_dup_build(self, item_to_duplicate, &block)
    end

    def pbt_deep_dup_build(item_to_duplicate, &block)
      self.class.pbt_deep_dup_build(self, item_to_duplicate, &block)
    end

  end
end
