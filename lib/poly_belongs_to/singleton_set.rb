require 'set'
module PolyBelongsTo
  class SingletonSet
    def initialize
      @set = Set.new
      self
    end

    def formatted_name(record)
      "#{record.class.name}-#{record.id}"
    end

    def add?(record)
      @set.add?( formatted_name( record ) )
    end

    def add(record)
      add?(record)
    end

    def <<(record)
      add?(record)
    end

    def method_missing(mthd)
      @set.send(mthd)
    end
  end  
end
