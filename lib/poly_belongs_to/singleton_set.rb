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

    def add(record)
      add?(record)
    end

    def <<(record)
      add?(record)
    end

    def flag(record)
      @flagged << formatted_name(record)
    end

    def flagged?(record)
      @flagged.include?(formatted_name(record))
    end

    def method_missing(mthd)
      @set.send(mthd)
    end
  end  
end
