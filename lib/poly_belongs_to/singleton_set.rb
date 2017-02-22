require 'set'
module PolyBelongsTo
  ##
  # PolyBelongsTo::SingletonSet is a modified instance of Set for maintaining singletons of ActiveRecord objects during any recursive flow.
  class SingletonSet
    # Creates two internal Sets
    # @return [self]
    def initialize
      @set = Set.new
      @flagged = Set.new
      self
    end

    # Takes ActiveRecord object and returns string of class name and object id
    # @param record [Object] ActiveRecord object instance
    # @return [String]
    def formatted_name(record)
      "#{record.class.name}-#{record.id}"
    end

    # Add record to set.  Flag if covered already.
    # @param record [Object] ActiveRecord object instance
    # @return [Object, nil] Object if added safely, nil otherwise
    def add?(record)
      result = @set.add?( formatted_name( record ) )
      return result if result
      flag(record)
      result
    end

    # Boolean of record inclusion
    # @param record [Object] ActiveRecord object instance
    # @return [true, false]
    def include?(record)
      return nil unless record
      @set.include?(formatted_name(record))
    end

    # Add record to flagged Set list
    # @param record [Object] ActiveRecord object instance
    # @return [Set]
    def flag(record)
      @flagged << formatted_name(record)
    end

    # Boolean of record inclusion in flagged Set
    # @param record [Object] ActiveRecord object instance
    # @return [true, false]
    def flagged?(record)
      return nil unless record
      @flagged.include?(formatted_name(record))
    end

    # method_missing will transform any record argument into a formatted string and pass the
    # method and arguments on to the internal Set.  Also will flag any existing records covered.
    def method_missing(mthd, *args, &block)
      new_recs = args.reduce([]) {|a, i| a.push(formatted_name(i)) if i.class.ancestors.include?(ActiveRecord::Base); a}
      result = @set.send(mthd,
        *(args.map do |arg|
            arg.class.ancestors.include?(ActiveRecord::Base) ? formatted_name(arg) : arg
          end
        ),
        &block
      )
      @set.to_a.select {|i| new_recs.include? i }.each {|f| @flagged << f}
      result
    end
  end
end
