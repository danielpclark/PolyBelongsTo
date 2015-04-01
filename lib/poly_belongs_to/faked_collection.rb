module PolyBelongsTo
  ##
  # PolyBelongsTo::FakedCollection emulates an ActiveRecord::CollectionProxy of exactly one or zero items
  class FakedCollection
    # Create the Faked Colllection Proxy
    def initialize(obj = nil, child = nil)
      @obj = obj
      @child = child
      if obj.nil? || child.nil?
        @instance = nil
      else
        raise "Not a has_one rleationship for FakedCollection" unless PolyBelongsTo::Pbt::IsSingular[obj,child]
        @instance = @obj.send(PolyBelongsTo::Pbt::CollectionProxy[@obj,@child])
      end
      self
    end

    # @return [Integer, nil]
    def id
      @instance.try(:id)
    end

    # @return [Array]
    def all
      Array[@instance].compact
    end

    # Boolean of empty?
    # @return [true, false]
    def empty?
      all.empty?
    end

    # Boolean of not empty?
    # @return [true, false]
    def present?
      !empty?
    end

    # @return [self, nil]
    def presence
      all.first ? self : nil
    end

    # Boolean of validity
    # @return [true, false]
    def valid?
      !!@instance.try(&:valid?)
    end

    # @return [Object, nil]
    def first
      @instance
    end

    # @return [Object, nil]
    def last
      @instance
    end

    # @return [Integer] 1 or 0
    def size
      all.size
    end

    # @return [Array<Object>]
    def ancestors
      klass.ancestors.unshift(PolyBelongsTo::FakedCollection)
    end
    
    # Boolean of kind match
    # @param thing [Object] object class
    # @return [true, false]
    def kind_of?(thing)
      ancestors.include? thing
    end

    # Boolean of kind match
    # @param thing [Object] object class
    # @return [true, false]
    def is_a?(thing)
      kind_of?(thing)
    end

    # alias for size
    # @return [Integer] 1 or 0
    def count
      size
    end

    # @return [Object] object class
    def klass
      @instance.class
    end

    # build preforms calculated build command and returns self
    # @param args [Array<Symbol>] arguments
    # @return [self]
    def build(*args)
      @instance = @obj.send(PolyBelongsTo::Pbt::BuildCmd[@obj, @child], *args)
      self
    end

    # @param args [Array<Symbol>] arguments
    # @return [Enumerator]
    def each(*args, &block)
      all.each(*args, &block)
    end

    # Returns whether this or super responds to method
    # @param method_name [Symbol]
    # @return [true, false]
    def respond_to?(method_name)
      @instance.respond_to?(method_name) || super
    end

    # Hands method and argument on to instance if it responds to method, otherwise calls super
    # @param method_name [Symbol]
    # @param args [Array<Symbol>] arguments
    # @return [true, false]
    def method_missing(method_name, *args, &block)
      if @instance.respond_to?(method_name)
        @instance.send method_name, *args, &block
      else
        super
      end
    end
  end
end
