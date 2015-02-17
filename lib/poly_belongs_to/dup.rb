module PolyBelongsTo
  module Dup
    extend ActiveSupport::Concern

    included do
      def self.pbt_dup(item_to_build_on, item_to_duplicate)

      end

      def self.pbt_deep_dup(item_to_build_on, item_to_duplicate)

      end
    end

    def pbt_dup(item_to_duplicate)
      self.class.pbt_dup(self, item_to_duplicate)
    end

    def pbt_deep_dup(item_to_duplicate)
      self.class.pbt_deep_dup(self, item_to_duplicate)
    end

  end
end
