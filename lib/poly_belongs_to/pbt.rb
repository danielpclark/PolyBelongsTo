module PolyBelongsTo
  ##
  # PolyBelongsTo::Pbt is where internal methods are for implementing core and duplication methods; available on all instances.
  # They are available for other use if the need should arise.
  module Pbt
    # Strips date and id fields dup'd attributes
    # @param obj [Object] ActiveRecord instance that has attributes
    # @return [Hash] attributes
    AttrSanitizer = lambda {|obj|
      return {} unless obj
      obj.dup.attributes.delete_if {|ky,vl|
        [:created_at, :updated_at, :deleted_at, obj.pbt_id_sym, obj.pbt_type_sym].include? ky.to_sym
      } 
    }

    # Discerns which type of build command is used between obj and child
    # @param obj [Object] ActiveRecord instance to build on
    # @param child [Object] ActiveRecord child relation as class or instance
    # @return [String, nil] build command for relation, or nil
    BuildCmd = lambda {|obj, child|
      return nil unless obj && child
      dup_name = CollectionProxy[obj, child]
      IsSingular[obj, child] ? "build_#{dup_name}" : IsPlural[obj, child] ? "#{dup_name}.build" : nil
    }

    # Returns all has_one and has_many relationships as symbols (reflec_on_all_associations)
    # @param obj [Object] ActiveRecord instance to reflect on
    # @return [Array<Symbol>]
    Reflects = lambda {|obj|
      return [] unless obj
      [:has_one, :has_many].flat_map { |has|
        obj.class.name.constantize.reflect_on_all_associations(has).map {|i| i.name.to_sym }
      }
    }

    # Returns all has_one and has_many relationships as class objects (reflec_on_all_associations)
    # @param obj [Object] ActiveRecord instance to reflect on
    # @return [Array<Object>]
    ReflectsAsClasses = lambda {|obj|
      Reflects[obj].map {|ref|
        (obj.send(ref).try(:klass) || obj.send(ref).class).name.constantize
      }
    }
    
    # Check if the child object is a kind of child that belongs to obj
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsReflected = lambda {|obj, child|
      !!CollectionProxy[obj, child]
    }

    # Plurality of object relationship (plural for has_many)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Symbol, nil] :plural, :singular, or nil
    SingularOrPlural = lambda {|obj, child|
      return nil unless obj && child
      reflects = Reflects[obj]
      if reflects.include?(ActiveModel::Naming.singular(child).to_sym)
        :singular
      elsif CollectionProxy[obj, child]
        :plural
      else
        nil
      end
    }

    # Singularity of object relationship (for has_one)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsSingular = lambda {|obj, child|
      SingularOrPlural[obj, child] == :singular
    }

    # Plurality of object relationship (for has_many)
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [true, false]
    IsPlural = lambda {|obj,child|
      SingularOrPlural[obj, child] == :plural
    }

    # Returns the symbol of the child relation object
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Symbol] working relation on obj
    CollectionProxy = lambda {|obj, child|
      return nil unless obj && child
      names = [ActiveModel::Naming.singular(child).to_s, ActiveModel::Naming.plural(child).to_s].uniq
      Reflects[obj].detect {|ref| "#{ref}"[/(?:#{ names.join('|') }).{,3}/]}
    }
  
    # Returns either a ActiveRecord::CollectionProxy or a PolyBelongsTo::FakedCollection as a proxy
    # @param obj [Object] ActiveRecord instance
    # @param child [Object] ActiveRecord instance or model class
    # @return [Object]
    AsCollectionProxy = lambda {|obj, child|
      return PolyBelongsTo::FakedCollection.new() unless obj && child
      return PolyBelongsTo::FakedCollection.new(obj, child) if IsSingular[obj, child]
      if CollectionProxy[obj, child]
        obj.send(PolyBelongsTo::Pbt::CollectionProxy[obj, child])
      else
        PolyBelongsTo::FakedCollection.new()
      end
    }
  end
  
end
