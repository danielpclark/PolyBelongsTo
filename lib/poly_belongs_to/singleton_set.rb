require 'set'
module PolyBelongsTo
  class SingletonSet
    def initialize
      @set = Set.new
      @flagged = Set.new
      self
    end

    def formatted_name(record)
      "#{record.class.name}-#{record.id}"
    end

    def add?(record)
      result = @set.add?( formatted_name( record ) )
      return result if result
      flag(record)
      result
    end

    # <b>DEPRECATED:</b> Please use <tt>add?</tt> instead. Behavior changing in 0.2.0.
    def add(record)
      warn "[DEPRECATION] `add` will revert to normal behavior in 0.2.0.  Please maintain behavior with `add?` instead."
      add?(record)
    end

    # <b>DEPRECATED:</b> Please use <tt>add?</tt> instead. Behavior changing in 0.2.0.
    def <<(record)
      warn "[DEPRECATION] `<<` will revert to normal behavior in 0.2.0.  Please maintain behavior with `add?` instead."
      add?(record)
    end

    def include?(record)
      return nil unless record
      @set.include?(formatted_name(record))
    end

    def flag(record)
      @flagged << formatted_name(record)
    end

    def flagged?(record)
      return nil unless record
      @flagged.include?(formatted_name(record))
    end

    def method_missing(mthd)
      # TODO Add parameter support and substiture record parameters with formatted_name(record)
      @set.send(mthd)
    end
  end  
end
