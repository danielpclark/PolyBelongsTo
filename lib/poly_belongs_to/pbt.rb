module PolyBelongsTo
  ##
  # PolyBelongsTo::Pbt is where internal methods are for implementing core and duplication methods; available on all instances.
  # They are available for other use if the need should arise.
  module Pbt
    # Strips date and id fields dup'd attributes
    # @param obj [Object] ActiveRecord instance that has attributes
    # @return [Hash] attributes
    AttrSanitizer = lambda do |obj|
      return {} unless obj
      obj.dup.attributes.delete_if do |ky, _|
        [:created_at, :updated_at, :deleted_at, obj.pbt_id_sym, obj.pbt_type_sym].include? ky.to_sym
      end
    end

    # Discerns which type of build command is used between obj and child
    # @param obj [Object] ActiveRecord instance to build on
    # @param child [Object] ActiveRecord child relation as class or instance
    # @return [String, nil] build command for relation, or nil
    BuildCmd = lambda do |obj, child|
      return nil unless obj && child
      dup_name = CollectionProxy[obj, child]
      if IsSingular[obj, child]
        "build_#{dup_name}"
      elsif IsPlural[obj, child]
        "#{dup_name}.build"
      end
    end

    # Returns all has_one and has_many relationships as symbols (reflect_on_all_associations)
    # @param obj [Object] ActiveRecord instance to reflect on
    # @param habtm [Object] optional boolean argument to include has_and_belongs_to_many
    # @return [Array<Symbol>]
    Reflects = lambda do |obj, habtm = false|
      return [] unless obj
      [:has_one, :has_many].
        tap {|array| array << :has_and_belongs_to_many if habtm }.
        flat_map do |has|
        obj.class.name.constantize.reflect_on_all_associations(has).map(&:name)
      end
    end

    # Returns all has_one and has_many relationships as class objects (reflect_on_all_associations)
    # @param obj [Object] ActiveRecord instance to reflect on
    # @param habtm [Object] optional boolean argument to include has_and_belongs_to_many
    # @return [Array<Object>]
    ReflectsAsClasses = lambda do |obj, habtm = false|
      Reflects[obj, habtm].map do |ref|
        (obj.send(ref).try(:klass) || obj.send(ref).class).name.constantize
      end
    end

    # Check if the child object is a kind of child that belongs to obj
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsReflected = lambda do |obj, child|
      !!CollectionProxy[obj, child]
    end

    # Plurality of object relationship (plural for has_many)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Symbol, nil] :plural, :singular, or nil
    SingularOrPlural = lambda do |obj, child|
      return nil unless obj && child
      reflects = Reflects[obj]
      if reflects.include?(ActiveModel::Naming.singular(child).to_sym)
        :singular
      elsif CollectionProxy[obj, child]
        :plural
      end
    end

    # Singularity of object relationship (for has_one)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsSingular = lambda do |obj, child|
      SingularOrPlural[obj, child] == :singular
    end

    # Plurality of object relationship (for has_many)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsPlural = lambda do |obj, child|
      SingularOrPlural[obj, child] == :plural
    end

    # Returns the symbol of the child relation object
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Symbol] working relation on obj
    CollectionProxy = lambda do |obj, child|
      return nil unless obj && child
      names = [ActiveModel::Naming.singular(child).to_s, ActiveModel::Naming.plural(child).to_s].uniq
      Reflects[obj].detect {|ref| "#{ref}"[/(?:#{ names.join('|') }).{,3}/]}
    end

    # Returns either a ActiveRecord::CollectionProxy or a PolyBelongsTo::FakedCollection as a proxy
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Object]
    AsCollectionProxy = lambda do |obj, child|
      return PolyBelongsTo::FakedCollection.new() unless obj && child
      return PolyBelongsTo::FakedCollection.new(obj, child) if IsSingular[obj, child]
      if CollectionProxy[obj, child]
        obj.send(PolyBelongsTo::Pbt::CollectionProxy[obj, child])
      else
        PolyBelongsTo::FakedCollection.new()
      end
    end
  end

end
