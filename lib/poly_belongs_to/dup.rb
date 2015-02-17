module PolyBelongsTo
  module Dup
    extend ActiveSupport::Concern

    included do
      def self.pbt_dup_build(item_to_build_on, item_to_duplicate)
        [:has_one, :has_many].each do |has|
          reflects = eval(item_to_build_on.class.name).reflect_on_all_associations(has).map(&:name).map(&:to_sym)
          if reflects.include?(ActiveModel::Naming.singular(item_to_duplicate).to_sym) or
              reflects.include?(ActiveModel::Naming.plural(item_to_duplicate).to_sym)

            build_cmd = PolyBelongsTo::Pbt::BuildCmd[has, item_to_duplicate]
            dup_attrs = PolyBelongsTo::Pbt::AttrSanitizer[item_to_duplicate]

            break build_cmd ? eval("item_to_build_on.#{build_cmd}(#{dup_attrs})") : nil
          end
        end
      end

      def self.pbt_deep_dup_build(item_to_build_on, item_to_duplicate)
        pbt_dup_build(item_to_build, item_to_duplicate)
        
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
