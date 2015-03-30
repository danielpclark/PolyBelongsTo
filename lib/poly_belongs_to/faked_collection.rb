module PolyBelongsTo
  class FakedCollection
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

    def id
      @instance.try(:id)
    end

    def all
      Array[@instance].compact
    end

    def empty?
      all.empty?
    end

    def present?
      !empty?
    end

    def presence
      all.first ? self : nil
    end

    def valid?
      !!@instance.try(&:valid?)
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

    def is_a?(thing)
      kind_of?(thing)
    end

    def count
      size
    end

    def klass
      @instance.class
    end

    def build(*args)
      @instance = @obj.send(PolyBelongsTo::Pbt::BuildCmd[@obj, @child], *args)
      self
    end

    def each(*args, &block)
      all.each(*args, &block)
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
