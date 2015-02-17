module PolyBelongsTo
  module Hierarchy
    extend ActiveSupport::Concern

    included do
      def self.pbt_offspring(obj)
        # planning phase
      end

      def self.pbt_children(obj, kind)
        # planning phase
      end
    end

    def pbt_offspring
      self.class.pbt_offspring(self)
    end

    def pbt_children(kind)
      self.class.pbt_children(self, kind)
    end
  end
end
