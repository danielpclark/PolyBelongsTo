module PolyBelongsTo
  module SortedReflectionDecorator
    def self.included(base)
      base.module_exec do
        original_method = instance_method(:reflect_on_all_associations)
        define_method(:reflect_on_all_associations) do |*args, &block|
          original_method.bind(self).call(*args, &block).sort_by {|a| a.polymorphic? ? 0 : 1 }
        end
      end
    end
  end
end
