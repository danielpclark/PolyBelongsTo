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

    def method_missing(mthd, *args, &block)
      pre = @set.to_a
      result = @set.send(mthd,
        *(args.map {|arg|
            arg.class.ancestors.include?(ActiveRecord::Base) ? formatted_name(arg) : arg
          }
        ),
        &block
      )
      (@set.to_a - pre).each {|f| @flagged << f}
      result
    end
  end  
end
