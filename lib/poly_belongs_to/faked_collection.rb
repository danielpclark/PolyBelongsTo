module PolyBelongsTo
  class FakedCollection
    def initialize(obj, child)
      raise "Not a has_one rleationship for FakedCollection" unless PolyBelongsTo::Pbt::IsSingular[obj,child]
      @obj = obj
      @child = child
      @instance = eval("@obj.#{PolyBelongsTo::Pbt::CollectionProxy[@obj,@child]}")
      self
    end

    def all
      Array[@instance].compact
    end

    def first
      @instance
    end

    def last
      @instance
    end

    def size
      all.size
    end

    def ancestors
      klass.ancestors.unshift(PolyBelongsTo::FakedCollection)
    end

    def kind_of?(thing)
      ancestors.include? thing
    end

    def count
      size
    end

    def klass
      @instance.class
    end

    def build(*args)
      @instance = eval("@obj.#{PolyBelongsTo::Pbt::BuildCmd[@obj, @child]}(#{args.join(',')})")
      self
    end

    def each
      all.each
    end

    def respond_to?(method_name)
      @instance.respond_to?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      if @instance.respond_to?(method_name)
        @instance.send method_name, *args, &block
      else
        super
      end
    end
  end
end
